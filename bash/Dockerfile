FROM ubuntu

#Basic image commands
RUN \
    apt-get update && \
    apt-get install --yes wget vim sudo && \
    apt-get clean

#Create <docker> user
ENV USER=docker  
ENV HOME=/home/$USER

RUN mkdir -p $HOME && \
    cp /etc/skel/.bashrc $HOME && \
    cp /etc/skel/.profile $HOME && \
    useradd -r -d $HOME -s /bin/bash -c "Docker image user" $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD install.sh $HOME/install.sh

RUN chown -R $USER $HOME

WORKDIR $HOME
USER $USER

 