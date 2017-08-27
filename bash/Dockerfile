FROM ubuntu
RUN \
    apt-get update && \
    apt-get upgrade && \
    apt-get install wget --yes && \
    apt-get install vim --yes
 
#RUN apt-get -y install sudo 
#RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
#USER docker
 
ADD install.sh /home/docker/install.sh
 
RUN sed -E -i "s/(.*)sudo (.*)/\1\2/" /root/install.sh
 