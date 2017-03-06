FROM ubuntu:zesty

MAINTAINER Andreas Schaeffer

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
    && groupadd 1001 -g 1001 \
    && groupadd 1000 -g 1000 \
    && useradd -ms /bin/bash jenkins -g 1001 -G 1000 \
    && echo "jenkins:jenkins" | chpasswd \
    && adduser jenkins sudo \
    && echo "jenkins ALL= NOPASSWD: ALL\n" >> /etc/sudoers

USER jenkins
WORKDIR /var/lib/jenkins
RUN mkdir -p /var/lib/jenkins/.conan

