FROM ubuntu

#Basic image commands
RUN \
    apt-get update && \
    apt-get install --yes wget vim sudo git && \
    apt-get clean

#Create <docker> user
ENV USER=docker  
ENV HOME=/home/$USER
ENV AUTOMATIONS_BASH_TMP_FOLDER=/tmp/automations

RUN mkdir -p $HOME && \
    cp /etc/skel/.bashrc $HOME && \
    cp /etc/skel/.profile $HOME && \
    useradd -r -d $HOME -s /bin/bash -c "Docker image user" $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD . $AUTOMATIONS_BASH_TMP_FOLDER 
ADD install.sh $HOME/install.sh

RUN chown -R $USER $HOME
RUN chown -R $USER $AUTOMATIONS_BASH_TMP_FOLDER

WORKDIR $HOME
USER $USER

 