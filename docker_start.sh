#!/bin/bash

docker container rm redis1
docker container rm mysql1
docker run --detach --name=mysql1 --network=br0 --ip 172.28.5.2 -v $PWD/mysql_scripts:/docker-entrypoint-initdb.d/ --env="MYSQL_ROOT_PASSWORD=root" ms:v1
docker run --detach --name=redis1 --network=br0 --ip 172.28.5.3  -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest 
