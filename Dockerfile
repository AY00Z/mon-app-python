
pipeline {
    agent {
        docker {
            image 'python:3.9-slim'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'pip install flask'
            }
        }
        stage('Test Application') {
            steps {
                sh '''
                    python app.py &
                    sleep 5
                    curl -f http://localhost:5000/health
                    pkill -f "python app.py"
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mon-app-python:latest .'
            }
        }
        stage('Test Docker Image') {
            steps {
                sh '''
                    docker run -d --name test-app -p 5002:5000 mon-app-python:latest
                    sleep 10
                    curl -f http://localhost:5002/health
                    docker stop test-app
                    docker rm test-app
                '''
            }
        }
    }
    post {
        always {
            sh 'docker rm -f test-app || true'
        }
    }
}
