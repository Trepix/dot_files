FROM ubuntu

#Basic image commands
RUN \
    apt-get update && \
    apt-get upgrade && \
    apt-get install wget vim sudo --yes

# Avoid reinstall git&zsh
#RUN \
#    apt-get install git --yes && \
#    apt-get install zsh --yes

#Create <docker> user
ENV USER=docker  
ENV HOME=/home/$USER
RUN mkdir -p $HOME && \
    useradd -r -d $HOME -s /sbin/nologin -c "Docker image user" $USER

RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR $HOME
ADD install.sh $HOME/install.sh

RUN chown -R $USER $HOME

USER $USER

 