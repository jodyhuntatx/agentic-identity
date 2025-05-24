#!/bin/bash

if [[ $1 == "all" ]]; then
  PERMS="ALL PRIVILEGES"
else
  PERMS="SELECT"
fi

source ../demo-vars.sh

  echo
  echo "Dropping existing database..."
  echo "drop database petclinic;"	\
  | $DOCKER exec -i mysql	\
        mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD
  echo
  echo "Initializing MySQL database..."
  # create db
  cat db_create_petclinic.sql          				\
  | $DOCKER exec -i mysql	\
        mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD
  echo
  echo "Loading data..."
  cat db_load_petclinic.sql            				\
  | $DOCKER exec -i mysql	\
        mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD

  # grant user access
  ./mysqldb-grant-user-access.sh $MYSQL_DBNAME $MYSQL_USERNAME $MYSQL_PASSWORD

  echo
  echo
  echo "Verifying petclinic database:"
  echo "use petclinic; select * from pets;" \
  | $DOCKER exec -i mysql	\
        mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD

