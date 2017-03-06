FROM ubuntu:zesty

MAINTAINER Andreas Schaeffer

ENV JENKINS_HOME /var/lib/jenkins

ARG user=jenkins
ARG group=jenkins
ARG uid=116
ARG gid=125

RUN dpkg --add-architecture i386 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get install -y python-dev sudo build-essential wget git vim libc6-dev-i386 g++-multilib libgmp-dev libmpfr-dev libmpc-dev libc6-dev nasm dh-autoreconf valgrind \
    && wget https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz --no-check-certificate \
    && tar -xzf cmake-3.7.2-Linux-x86_64.tar.gz \
    && cp -fR cmake-3.7.2-Linux-x86_64/* /usr \
    && rm -rf cmake-3.7.2-Linux-x86_64 \
    && rm cmake-3.7.2-Linux-x86_64.tar.gz \
    && wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate \
    && python get-pip.py \
    && pip install -U pip \
    && pip install conan \
    && groupadd ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -ms /bin/bash ${user} \
    && echo "jenkins:jenkins" | chpasswd \
    && adduser jenkins sudo \
    && echo "jenkins ALL= NOPASSWD: ALL\n" >> /etc/sudoers

USER ${user}
WORKDIR /var/lib/jenkins

