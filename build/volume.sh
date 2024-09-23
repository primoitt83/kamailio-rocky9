#!/bin/bash

mkdir -p kamailio
docker cp kamailio:/etc/kamailio/. ./kamailio/.

docker-compose down
cp docker-compose.yml docker-compose.yml.bkp
cp docker-compose.vol.yml docker-compose.yml
docker-compose up -d