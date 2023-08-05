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
       stage('Build Docker Image'){
		sh "docker build -t fifemateen/docker-jenkins:${env.BUILD_ID} ."
	}

        stage('Push Image to Docker Hub'){
		withCredentials([string(credentialsId: 'docker_hub', variable: 'docker_hub')]) {
			sh "docker login -u fifemateen -p ${docker_hub}"
		}
		sh "docker push fifemateen/docker-jenkins:${env.BUILD_ID}"
	}

        stage('Push Image in ECR'){
		ECRURL = 'https://060213843072.dkr.ecr.us-east-2.amazonaws.com'
		ECRRED = 'ecr:us-east-2:awscredentials'
		docker.withRegistry("${ECRURL}","${ECRRED}"){
			docker.image("fifemateen/docker-jenkins:${env.BUILD_ID}").push()
		}
	}

        stage('Run Container on AWS Server'){
		def dockerRun = "docker run -d -p 8080:8080 --name myapp-${env.BUILD_ID} fifemateen/docker-jenkins:${env.BUILD_ID}"
		sshagent(['aws_instance']) {
		    sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.31.83 ${dockerRun}"
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
