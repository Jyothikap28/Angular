pipeline {
    agent any
    tools {
        nodejs 'nodejs'
    }
    environment {
        IMAGE_NAME='jyothikap28/test'
        TAG='v1'
    }
    stages{
        stage("Code SCM"){
            steps{
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
                  IMG=docker.build("${env.IMAGE_NAME}:${env.TAG}")
                }
            }
        }
        stage("push docker image to hub"){
            steps{
              script{
                    IMG.push()
              }
            }
        }
        stage("deploy to conatiner"){
            steps{
                script{
                    sh "docker run -d --name MYAPP -p 82:80 ${env.IMAGE_NAME}:${env.TAG}"
                }
            }
        }
    }
}
