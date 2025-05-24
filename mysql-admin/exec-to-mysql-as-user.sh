#!/bin/bash

source ../demo-vars.sh

$DOCKER exec -it mysql \
        mysql -h $MYSQL_SERVER_ADDRESS -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD 
