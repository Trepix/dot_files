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
    groupadd -r $USER &&\
    useradd -r -g $USER -d $HOME -s /sbin/nologin -c "Docker image user" $USER && \
    echo "$USER:$USER" | chpasswd && \
    adduser $USER sudo

WORKDIR $HOME
ADD install.sh $HOME/install.sh

RUN chown -R $USER:$USER $HOME

USER $USER

 