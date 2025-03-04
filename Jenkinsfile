pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '982081069151'
        REPO_NAME = 'my-java-app'
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: '89483931-e784-4e4c-957b-8afb03573d42',
                    url: 'git@github.com:ranadesh/traildocker.git'
            }
        }

        stage('Compile Java Code') {
            steps {
                sh 'mvn clean package -DskipTests' // Using Maven instead of manual compilation
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Login to AWS ECR') {
    steps {
        withCredentials([
            string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            script {
                def awsRegion = "ap-south-1"
                def awsAccountId = "982081069151"
                def ecrRepository = "my-repo"  // Replace with your ECR repository name
                def ecrUrl = "${awsAccountId}.dkr.ecr.${awsRegion}.amazonaws.com/${ecrRepository}"

                sh """
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                export AWS_REGION=${awsRegion}
                export AWS_ACCOUNT_ID=${awsAccountId}

                # Validate AWS CLI authentication
                aws sts get-caller-identity || exit 1

                # Login to AWS ECR
                aws ecr get-login-password --region ${awsRegion} | \
                docker login --username AWS --password-stdin ${awsAccountId}.dkr.ecr.${awsRegion}.amazonaws.com

                echo "Successfully logged in to AWS ECR: ${ecrUrl}"
                """
                
                // Store ECR URL in an environment variable for later use
                env.ECR_URL = ecrUrl
            }
        }
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



