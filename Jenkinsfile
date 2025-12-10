pipeline {
    agent any
    tools {
        nodejs 'nodejs'
    }
    environment {
        IMAGE_NAME='jyothikap28/test'
        TAG="${env.BUILD_NUMBER}"
    }
    options {
        skipDefaultCheckout()
        disableConcurrentBuilds()
        timestamps()
    }
    stages{
        stage("Code SCM"){
            steps{
                echo " *** Fetching code form github repo *** "
                git 'https://github.com/Jyothikap28/Angular.git'
            }
        }
        stage("Install node dependencies"){
            steps{
                sh 'npm install --legacy-peer-deps'
            }
        }
        stage("Build Angular Project"){
            steps{
                sh 'npm run build --prod'
            }
        }
        stage("Login to DockerHub"){
            steps{
               withCredentials([usernamePassword(
                   credentialsId:'docker-creds',
                   usernameVariable:'DOCKER_USER',
                   passwordVariable:'DOCKER_PASS')]){
                       sh '''
                       echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                       '''
                   }
            }
        }
        stage("Build docker image"){
            steps{
                script{
                  echo " *** Building docker image *** "
                  IMG=docker.build("${env.IMAGE_NAME}:${env.TAG}")
                }
            }
        }
        stage("push docker image to hub"){
            steps{
              script{
                    echo " *** Pushing the docker image to docker hub *** "
                    IMG.push()
              }
            }
        }
        stage("deploy to conatiner"){
            steps{
                script{
                    echo " *** Deleting the existing container *** "
                    sh "docker rm -f MYAPP || true"

                    echo " ** Running new container ** "
                    sh "docker run -d --name MYAPP -p 81:80 ${env.IMAGE_NAME}:${env.TAG}"
                }
            }
        }
    }
    post{
	    success {
 	        echo "Pipeline executed successfully!!!"
            echo "Version: ${TAG}"
            echo "Image pushed : ${IMAGE}:${TAG}"
	    }
	failure {
	     echo "pipeline failed fix and re-run it.."
	    }
    }
}
