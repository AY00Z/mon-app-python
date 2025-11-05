pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AY00Z/mon-app-python.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mon-app-python:latest .'
            }
        }
        stage('Test') {
            steps {
                sh '''
                    docker run -d --name test-app -p 5002:5000 mon-app-python:latest
                    sleep 5
                    curl -f http://localhost:5002/health || exit 1
                    docker stop test-app
                    docker rm test-app
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d'
            }
        }
    }
    post {
        always {
            sh 'docker rm -f test-app || true'
        }
    }
}
