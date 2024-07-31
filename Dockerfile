FROM alpine:3.20

LABEL description "PostfixAdmin is a web based interface used to manage mailboxes" \
      maintainer="Neo.aka.Darkman <developer@fantasia-wmc.com>" \
      former_maintainer="Hardware <contact@meshup.net>"

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    ca-certificates \
    gnupg \
 && apk add \
    su-exec \
    dovecot \
    tini@community \
    php83@community \
    php83-phar@community \
    php83-fpm@community \
    php83-imap@community \
    php83-pgsql@community \
    php83-mysqli@community \
    php83-session@community \
    php83-mbstring@community \
 && cd /tmp \
 && wget -q https://github.com/postfixadmin/postfixadmin/archive/refs/heads/master.zip \
 && mkdir /postfixadmin && unzip postfixadmin-master.zip -d /postfixadmin && mv /postfixadmin/postfixadmin-master/* /postfixadmin \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/* /postfixadmin/postfixadmin-master*

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
