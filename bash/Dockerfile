FROM ubuntu

#Basic image commands
RUN \
    apt-get update && \
    apt-get install --yes wget vim sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#Create <docker> user
ENV USER=docker  
ENV HOME=/home/$USER

RUN mkdir -p $HOME && \
    useradd -r -d $HOME -s /sbin/nologin -c "Docker image user" $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD install.sh $HOME/install.sh

RUN chown -R $USER $HOME

WORKDIR $HOME
USER $USER

 