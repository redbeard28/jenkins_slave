# Dockerfile
FROM docker:stable

MAINTAINER redbeard28 <https://github.com/redbeard28/docker_mkdocs>

ENV SWARM_CLIENT_VERSION="3.9"

RUN adduser -G root -D jenkins && \
    apk --update --no-cache add build-base wget openjdk8-jre python python2-dev libffi-dev libressl-dev py-pip git openssh ca-certificates openssl && \
    wget -O swarm-client.jar -q https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_CLIENT_VERSION}/swarm-client-${SWARM_CLIENT_VERSION}.jar -P /home/jenkins/ && \
    pip install docker-compose

COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod +x /usr/local/bin/jenkins-slave
ENTRYPOINT ["jenkins-slave"]