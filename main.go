package main

import (
	"html/template"
	"net/http"
	"sync"
	"path/filepath"
)

var (
	tmpl  *template.Template
	todos []string
	mu    sync.Mutex
)

func init() {
	var err error
	tmpl, err = template.ParseFiles("./templates/index.html")
	if err != nil {
		panic(err)
	}
}

func main() {
	http.HandleFunc("./static/", serveStatic)
	http.HandleFunc("/", todoList)
	http.HandleFunc("/add", addTodo)
	http.ListenAndServe(":8080", nil)
}


func serveStatic(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, r.URL.Path[1:])
}

func todoList(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	defer mu.Unlock()

	tmpl.Execute(w, todos)
}

func addTodo(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	todo := r.FormValue("todo")

	mu.Lock()
	todos = append(todos, todo)
	mu.Unlock()

	http.Redirect(w, r, "/", http.StatusSeeOther)
}
