/* ADD COMMENTS TO PUSH AGAIN */


pipeline {

    agent any
    environment {
        DOCKER_NODE = ''
        branchVName = 'master'
        TAG = '0.7'
        DOCKER_TCPIP = ''
    }

    stages{

        stage('Clone the GitHub repo'){
            steps{
                git url: "https://github.com/redbeard28/jenkins_slave.git", branch: "${branchVName}", credentialsId: "jenkins_github_pat"
            }
            post{
                success{
                    echo 'Succefuly clone your repo...'
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
                        /* def customImage = docker.build("redbeard28/jenkins_slave:${TAG}","--build-arg DOCKER_TCP=${DOCKER_TCP}")
                        customImage.push() */
                        withDockerRegistry([credentialsId: 'DOCKERHUB', url: "https://index.docker.io/v1/"]) {
                            def image = docker.build("redbeard28/jenkins_slave:${TAG}","--build-arg DOCKER_TCPIP=${DOCKER_TCPIP}")
                            image.push()
                        }
                    }
                }

            }
        }
    }
}