#!/bin/bash
set -e

## Send ips from env
sed -i "s/KAMAILIO_IP_INTERNO/$KAMAILIO_IP_INTERNO/g" /etc/kamailio/config.cfg
sed -i "s/KAMAILIO_IP_EXTERNO/$KAMAILIO_IP_EXTERNO/g" /etc/kamailio/config.cfg
sed -i "s/KAMAILIO_IP_DB/$KAMAILIO_IP_DB/g" /etc/kamailio/config.cfg
sed -i "s/POSTGRES_USER/$POSTGRES_USER/g" /etc/kamailio/config.cfg
sed -i "s/POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" /etc/kamailio/config.cfg
sed -i "s/RTPENGINE_IP/$RTPENGINE_IP/g" /etc/kamailio/config.cfg

sed -i "s/KAMAILIO_IP_DB/$KAMAILIO_IP_DB/g" /etc/kamailio/kamctlrc
sed -i "s/DB_NAME/$DB_NAME/g" /etc/kamailio/kamctlrc
sed -i "s/POSTGRES_USER/$POSTGRES_USER/g" /etc/kamailio/kamctlrc
sed -i "s/POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" /etc/kamailio/kamctlrc

sed -i "s/DOMINIO_BASE/$DOMINIO_BASE/g" /etc/kamailio/tls.cfg

if [ "$( PGPASSWORD=$POSTGRES_PASSWORD psql -h $KAMAILIO_IP_DB -p 5432 -U $POSTGRES_USER -XtAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" )" != '1' ]
then
    ## db does not exists, lets create
    PGPASSWORD=$POSTGRES_PASSWORD kamdbctl create
    sleep 10
    PGPASSWORD=$POSTGRES_PASSWORD psql -h $KAMAILIO_IP_DB -p 5432 -U $POSTGRES_USER -d $DB_NAME < /etc/kamailio/tabelas_view.sql
fi

## check selfsigned
if [ "$SELFSIGNED" == true ]; then
    if [ ! -d "/etc/certs/$DOMINIO_BASE/key.pem" ]; then
        ## does not exists, lets create
        mkdir -p /etc/certs/$DOMINIO_BASE
        openssl req -x509 -newkey rsa:4096 -keyout /etc/certs/$DOMINIO_BASE/key.pem -out \
            /etc/certs/$DOMINIO_BASE/fullchain.pem -days 3650 -subj \
            "/C=BR/ST=Sao Paulo=Marilia/O=FAL/OU=FAL/CN=*.kamailio.local" -nodes -sha256
    fi            
fi

# shellcheck disable=SC2068
exec $@
