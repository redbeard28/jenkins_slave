
FROM openjdk:8-jdk-alpine
MAINTAINER Jeremie CUADRADO <https://github.com/redbeard28/jenkins_slave.git>

ARG VERSION=3.29
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG DOCKER_TCPIP


USER root

RUN addgroup -g ${gid} ${group}
RUN adduser -h /home/${user} -u ${uid} -G ${group} -D ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="${VERSION}"

ARG AGENT_WORKDIR=/home/${user}/agent

RUN echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/edge/community" >> /etc/apk/repositories
RUN apk update \
  && apk add --update --no-cache docker shadow rsync grep build-base wget curl bash python python2-dev libffi-dev libressl-dev py-pip git git-lfs openssh-client openssl procps \
  && curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && pip install ansible

RUN usermod -a -G docker jenkins

USER ${user}
RUN echo "export DOCKER_HOST=tcp://${DOCKER_TCPIP}" >> ~/.bashrc && \
    source ~/.bashrc

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}