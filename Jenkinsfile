pipeline {
    agent any

    environment {
        TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        max = 20
        random_num = "${Math.abs(new Random().nextInt(max + 1))}"
        docker_password = credentials('dockerhub_password')
    }

    stages {
        stage('Workspace Cleanup') {
            steps {
                dir("${WORKSPACE}") {
                    deleteDir()
                }
            }
        }

        stage('Checkout Git') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/Hack-Light/php-todo-20.git'
            }
        }

        stage('Building application') {
            steps {
                script {
                    sh " docker login -u hacklight -p '${docker_password}'"
                    sh " docker build -t hacklight/todo-project-20:${env.TAG} ."
                }
            }
        }

        stage('Creating docker container') {
            steps {
                script {
                    sh " docker run -d --name todo-app-${env.random_num} -p 8000:8000 hacklight/todo-project-20:${env.TAG}"
                }
            }
        }

        // stage('Smoke Test') {
        //     steps {
        //         script {
        //             sh 'sleep 60'
        //             sh 'curl -I 54.167.99.240:8000'
        //         }
        //     }
        // }

        stage('Publish to Registry') {
            steps {
                script {
                    sh " docker push hacklight/todo-project-20:${env.TAG}"
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    sh " docker stop todo-app-${env.random_num}"
                    sh " docker rm todo-app-${env.random_num}"
                    sh " docker rmi hacklight/todo-project-20:${env.TAG}"
                }
            }
        }

        stage('logout Docker') {
            steps {
                script {
                    sh ' docker logout'
                }
            }
        }
    }
}
