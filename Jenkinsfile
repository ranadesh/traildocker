pipeline {
    agent any

    environment {
        AWS_REGION = 'your-region'  // e.g., us-east-1
        AWS_ACCOUNT_ID = 'your-account-id'
        REPO_NAME = 'your-ecr-repository'
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:your-username/your-repo.git'
            }
        }

        stage('Compile Java Code') {
            steps {
                sh 'javac src/main/java/com/example/App.java -d target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG .'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com'
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh 'docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG'
            }
        }

        stage('Cleanup Docker') {
            steps {
                sh 'docker rmi $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG || true'
            }
        }
    }
}

