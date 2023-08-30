#!/bin/bash

#Ensure exit when error is detected
set -e 

##
## Defaults
unset USER
unset PASSWORD
unset DATABASE


##
## Parse command line
for i in "$@"
do
case $i in
    -u=*|--user=*)
    USERNAME="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--database=*)
    DATABASE="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--password=*)
    PASSWORD="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

sed -i -e 's/COWRIE_DB_USERNAME/'"${USERNAME}"'/g' -e 's/COWRIE_DB_PASSWORD/'"${PASSWORD}"'/g' -e 's/COWRIE_DB_SCHEMA/'"${DATABASE}"'/g' datasource/mysql.json

for i in datasource/*; do \
    curl -X "POST" "http://grafana:3000/api/datasources" \
    -H "Content-Type: application/json" \
    --user admin:admin \
    --data-binary @$i
done

for i in dashboard/*; do \
    curl -X "POST" "http://grafana:3000/api/dashboards/db" \
    -H "Content-Type: application/json" \
    --user admin:admin \
    --data-binary @$i
done
