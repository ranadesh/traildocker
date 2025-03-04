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
                script {
                def awsRegion = "ap-south-1"
                def awsAccountId = "982081069151"
                def ecrRepository = "my-java-app"
                def ecrUrl = "${awsAccountId}.dkr.ecr.${awsRegion}.amazonaws.com/${ecrRepository}"

            sh """
                # Hardcoded AWS credentials
                export AWS_ACCESS_KEY_ID="AKIA6JKEX4BP5SZZUTUB"
                export AWS_SECRET_ACCESS_KEY="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"
                export AWS_REGION="${awsRegion}"

                # AWS ECR login
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin ${awsAccountId}.dkr.ecr.$AWS_REGION.amazonaws.com

               

                echo "Successfully logged in to AWS ECR: ${ecrUrl}"
            """

            // Store ECR URL in an environment variable for later use
            env.ECR_URL = ecrUrl
        }
    }
}

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG
                '''
            }
        }

        stage('Cleanup Docker') {
            steps {
                sh '''
                docker rmi $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG || true
                '''
            }
        }
    }
}
