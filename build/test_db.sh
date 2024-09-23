#!/bin/sh
KAMAILIO_IP_DB=172.25.0.9 ## postgres ip
POSTGRES_USER=postgres ## db root
POSTGRES_PASSWORD=58e1bab9f6613cce680ed55245a91d30 ## db root pass
DB_NAME=kamailio

if [ "$( PGPASSWORD=$POSTGRES_PASSWORD psql -h $KAMAILIO_IP_DB -p 5432 -U $POSTGRES_USER -XtAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" )" != '1' ]
then
    echo "db does not exists"
else
    echo "db exists"
fi