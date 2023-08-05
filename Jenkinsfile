pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="060213843072"
        AWS_DEFAULT_REGION="us-east-2"
        IMAGE_REPO_NAME="gitops"
        IMAGE_TAG="latest"
        REPOSITORY_URI= "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }

    stages {
       
        stage('Logging into AWS ECR') {
            steps {
                    
                script {sh "docker login --username AWS --password-stdin 060213843072.dkr.ecr.us-east-2.amazonaws.com"
                }
            }
        }
        stage('Cloning git') {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Mateen12a/gitopsapi.git']])
                }
            }
        }
        
        stage ('Building Image') {
            steps {
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage ('Pushing to ECR') {
            steps {
                script{
                    docker.withRegistry('https://060213843072.dkr.ecr.us-east-2.amazonaws.com', 'ecr:us-east-2:aws-credentials') {                    
                    dockerImage.push("${env.BUILD_NUMBER}")
                    dockerImage.push("latest")
                    }
                }
            }
        }
        stage ('Updating the Deployment File') {
            environment {
                GIT_REPO_NAME = "gitopsapi"
                GIT_USER_NAME = "Mateen12a"
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]){
                    sh '''
                    
                        git pull https://github.com/Mateen12a/gitopsapi.git
                        git config  user.email "ajidagbamateen12@gmail.com"
                        git config  user.name "Mateen12a"
                        BUILD_NUMBER=${BUILD_NUMBER}
                        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" ArgoCD/deployments.yml
                        git add ArgoCD/deployments.yml
                        git commit -m "updated the image ${BUILD_NUMBER}"
                        git push @github.com/${GIT_USER_NAME}/${GIT_REPO_NAME">@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME">@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME">https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                        
                       
                    '''
                }
            }
        }
    }

}
