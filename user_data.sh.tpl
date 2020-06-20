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
    
    git clone https://${token}:x-oauth-basic@github.com/sergpsw/docker-LEMP.git
    cd docker-LEMP
    echo -ne "DUMP_FILE=${DUMP_FILE} \nDB_NAME=${DB_NAME} \nDB_USER=${DB_USER} \nDB_PASSWORD=${DB_PASSWORD} \nDB_HOST=${DB_HOST} \nDB_PORT=${DB_PORT} \nSERVER_PORT=${SERVER_PORT} \nPHP_PORT=${PHP_PORT}" > .env
    docker-compose build
    docker-compose up -d
  else
    echo "This example works for OS Debian family!"
    exit 1
fi
