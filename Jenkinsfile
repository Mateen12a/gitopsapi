node {
	


    
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

        
}
