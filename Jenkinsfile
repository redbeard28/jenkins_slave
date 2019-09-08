/* ADD COMMENTS TO PUSH AGAIN */


pipeline {

    agent any
    environment {
        DOCKER_NODE = ''
        branchVName = 'master'
        TAG = '0.7'
    }

    stages{

        stage('Clone the GitHub repo'){
            steps{
                git url: "https://github.com/redbeard28/jenkins_slave.git", branch: "${branchVName}", credentialsId: "jenkins_github_pat"
            }
            post{
                success{
                    echo 'Successfuly clone your repo...'
                }
            }
        }
        stage('Build the Image...'){
            /*steps{
                timeout(time:5, unit:'MINUTES'){
                    input message:'Approuve Image Building'
                }
            }*/
            steps{
                script {
                    withDockerServer([uri: "tcp://${DOCKER_TCPIP}"]) {
                        withDockerRegistry([credentialsId: 'DOCKERHUB', url: "https://index.docker.io/v1/"]) {
                            def image = docker.build("redbeard28/jenkins_slave:${TAG}","--build-arg DOCKER_TCPIP=${DOCKER_TCPIP}","-f Dockerfile .")
                            image.push()
                        }
                    }
                }

            }
        }
    }
}