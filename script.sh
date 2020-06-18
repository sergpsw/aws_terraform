#!/bin/bash

set -e

if [[ "ls -a  /etc/debian_version" ]]
  then
    apt update
    apt install git

    apt update
    apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt update
    apt install docker-ce -y

    curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # git clone https://${TF_VAR_github_token}:x-oauth-basic@github.com/sergpsw/docker-LEMP.git
    # git clone https://github.com/sergpsw/docker-LEMP.git
    git clone https://ed12551a357c9b4b16cead4a403b589f81767e29:x-oauth-basic@github.com/sergpsw/docker-LEMP.git
    cd docker-LEMP
    cp .env.example .env
    docker-compose build
    docker-compose up -d
    docker exec -T mysql mysql -uroot -proot ${DB_NAME} < dump.sql
  else
    echo "This example works for OS Debian family!"
    exit 1
fi
