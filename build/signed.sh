#!/bin/sh

openssl rand -writerand ~/.rnd
mkdir ca certs csv csr kamailio

openssl genrsa -out ./ca/kamailio-CA.key 4096

# Certificado para 100 anos
openssl req -x509 -new -nodes -key ./ca/kamailio-CA.key -sha256 -days 36500 -out ./ca/kamailio-CA.crt -subj "/C=/ST=/L=/O=/OU=/CN=kamailio.local/emailAddress="

openssl req -new -sha256 -nodes -out ./csr/kamailio.csr -newkey rsa:2048 -keyout ./certs/kamailio.key -subj "/C=/ST=/L=/O=/OU=/CN=kamailio.local/emailAddress="

cat > ./csr/openssl-v3.cnf <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = kamailio.local
EOF

openssl x509 -req -in ./csr/kamailio.csr -CA ./ca/kamailio-CA.crt -CAkey ./ca/kamailio-CA.key -CAcreateserial -out ./certs/kamailio.crt -days 36500 -sha256 -extfile ./csr/openssl-v3.cnf

cat ./certs/kamailio.crt ./certs/kamailio.key > ./certs/kamailio.pem

cp ./certs/* ./kamailio
cp ./ca/kamailio-CA.crt ./kamailio
ls  -lah ./kamailio/