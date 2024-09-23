FROM rockylinux:9

RUN \
    dnf -y update && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    crb enable && \
    dnf -y install https://opensource.vsphone.com.br/vsphone-opensource.rpm

## install Kamailio
RUN \
    dnf -y install kamailio kamailio-websocket \
    kamailio-postgresql kamailio-jansson kamailio-presence kamailio-outbound \
    kamailio-regex kamailio-utils kamailio-json kamailio-uuid kamailio-tcpops \
    kamailio-tls kamailio-dmq_userloc kamailio-geoip2 sngrep wget dos2unix postgresql

# Cleanup
RUN \
    dnf clean all && \
    dnf autoremove -y

# copy files
COPY ${PWD}/kamailio.cfg /etc/kamailio/kamailio.cfg
COPY ${PWD}/config.cfg /etc/kamailio/config.cfg
COPY ${PWD}/tls.cfg /etc/kamailio/tls.cfg
COPY ${PWD}/kamctlrc /etc/kamailio/kamctlrc
COPY ${PWD}/tabelas_view.sql /etc/kamailio/tabelas_view.sql
COPY ${PWD}/kss /usr/bin/kss

## copy new entrypoint.sh
COPY ${PWD}/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

## fix kss 
RUN \
    dos2unix /usr/bin/kss && \
    chmod +x /usr/bin/kss

EXPOSE 5060 5060/udp 8080 5061 5090/udp 8443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["kamailio -E -DD -P /run/kamailio/kamailio.pid -f /etc/kamailio/kamailio.cfg"]