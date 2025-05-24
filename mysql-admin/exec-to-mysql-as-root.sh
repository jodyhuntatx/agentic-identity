#!/bin/bash

source ../demo-vars.sh

$DOCKER exec -it mysql \
        mysql -h $MYSQL_SERVER_ADDRESS -u root --password=$MYSQL_ROOT_PASSWORD 
