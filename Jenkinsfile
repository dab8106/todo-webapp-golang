pipeline {
    agent any

   tools {
       go 'go-1.21.3'
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Reference Jenkins credential ID
    }

    stages {
    //     stage('Unit Test') {
    //         steps {
    //             script {
    //                 sh 'go mod init todo-app'
    //                 sh 'go test -v'
    //             }
    //         }
    //     }

    //     stage('Coverage Report') {
    //         steps {
    //             script {
    //                 sh 'go test -coverprofile=coverage.out'
    //                 sh 'go tool cover -html=coverage.out -o coverage.html'
    //             }
    //             archiveArtifacts 'coverage.html'
    //         }
    //     }

    //     stage('Run SonarQube Analysis') {
    //         steps {
    //             script {
    //                 withSonarQubeEnv('SONAR_TOKEN') {
    //                     sh '/usr/local/sonar/bin/sonar-scanner -Dsonar.organization=wm1 -Dsonar.projectKey=wm1_todo-webapp-golang -Dsonar.sources=. -Dsonar.host.url=https://sonarcloud.io'
    //                 }
    //             }
    //         }
    //     }

    //     stage('Build') {
    //         steps {
    //             script {
    //                 // Adjust these commands based on how you build and upload your Go application to Nexus
    //                 sh 'go build -o todoapp'
    //                 // sh 'curl -u username:password -X PUT --upload-file your-app https://nexus.example.com/repository/your-repo/your-app/1.0.0/your-app-1.0.0'
    //             }
    //             archiveArtifacts 'todoapp'
    //         }
    //     }

    //     stage('Build Docker Image') {
    //        steps {
    //            script {
    //                sh 'docker build -t dab8106/todo-webapp-golang .'
    //            }
    //        }
    //    }

    //     stage('Push Docker Image') {
    //        steps {
    //            script {
    //                withCredentials([usernamePassword(credentialsId: 'DOCKER_REGISTRY_CREDENTIALS_ID', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
    //                    sh """
    //                        echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin
    //                        docker push dab8106/todo-webapp-golang
    //                    """
    //                }
    //            }
    //        }
    //    }

        stage('Terraform Apply') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }
            steps {
                script {
                    sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        cd /terraform
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }


    post {
        always {
            cleanWs()
        }
    }
}
