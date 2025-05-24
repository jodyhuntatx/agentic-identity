#!/bin/bash

source ../demo-vars.sh

if [[ $# != 3 ]]; then
  echo "Usage: $0 <db-name> <username> <password>"
  exit -1
fi
DB_NAME=$1
DB_UNAME=$2
DB_PWD=\'$3\'
DB_URL="localhost"
echo
echo "MySQL: Provisioning access for $DB_UNAME to database $DB_NAME..."
echo "DROP USER $DB_UNAME;"	\
  | $DOCKER exec -i mysql	\
        mysql -h $DB_URL -u root --password=$MYSQL_ROOT_PASSWORD
echo "CREATE USER $DB_UNAME IDENTIFIED BY $DB_PWD REQUIRE NONE; GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_UNAME;"  \
  | $DOCKER exec -i mysql	\
        mysql -h $DB_URL -u root --password=$MYSQL_ROOT_PASSWORD
