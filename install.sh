#!/bin/sh

cd / && sudo rm -rf runner && \
sudo git clone https://github.com/ctukraine22/runner && sudo chmod -R a+rwx /runner

FILE=/usr/installed.done
if [ -f "$FILE" ]; then
    echo "Installed already."
else
    sudo apt-get update && \
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get update && \
        sudo apt-get -y install docker-ce docker-ce-cli containerd.io && \
        sudo docker run hello-world && \
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    sudo chmod +x /usr/local/bin/docker-compose
    sudo touch $FILE
fi
DIR="/runner/uashield/"
if [ -d "$DIR" ]; then
    echo "Updating uashield"
    cd $DIR
    sudo git pull
else
    echo "downloading uashield"
    sudo git clone https://github.com/opengs/uashield.git $DIR
fi

