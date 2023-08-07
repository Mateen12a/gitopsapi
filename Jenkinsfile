pipeline {
    agent any

    environment {
        // Define AWS ECR repository information
        ECR_REGISTRY = "060213843072.dkr.ecr.us-east-2.amazonaws.com"
        ECR_REPO_NAME = "gitops"
        DOCKER_IMAGE_TAG = "latest"
        AWS_REGION = "us-east-2" // Replace this with the actual AWS region
    }

    stages {
        stage('Checkout') {
            steps {
                // Check out the code from the Git repository
                // Make sure you have the proper Git credentials configured in Jenkins
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile in the /web folder
                    def dockerImage = docker.build("${ECR_REGISTRY}/${ECR_REPO_NAME}:${DOCKER_IMAGE_TAG}", "./web")

                    // Tag the image for pushing to ECR
                    dockerImage.tag("${ECR_REGISTRY}/${ECR_REPO_NAME}:${DOCKER_IMAGE_TAG}")

                    // Display the Docker image details
                    dockerImage.inside {
                        sh 'docker images'
                    }
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    // Read AWS credentials from Jenkins credentials
                    withCredentials([string(credentialsId: '73386119-c3fe-45d8-9b03-fb09ceb80d02', variable: 'AWS_CREDENTIALS')]) {
                        // Configure AWS CLI with the credentials from Jenkins
                        sh "aws configure set aws_access_key_id ${AWS_CREDENTIALS}"
                        sh "aws configure set aws_secret_access_key ${AWS_CREDENTIALS}"

                        // Log in to AWS ECR using the AWS CLI
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"

                        // Push the Docker image to AWS ECR
                        sh "docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${DOCKER_IMAGE_TAG}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images after the build is complete
            sh 'docker system prune -f'
        }
        success {
            echo 'Build and push successful!'
        }
        failure {
            echo 'Build or push failed!'
        }
    }
}

// "Dummy Stage" outside the post section
stage('Dummy Stage') {
    steps {
        echo 'This is a dummy stage for Jenkins pipeline'
    }
}
