FROM alpine:3.20

LABEL description "PostfixAdmin is a web based interface used to manage mailboxes" \
      maintainer="Neo.aka.Darkman <developer@fantasia-wmc.com>" \
      former_maintainer="Hardware <contact@meshup.net>"

ARG VERSION=3.3.13
ARG SHA256_HASH="866d4c0ca870b2cac184e5837a4d201af8fcefecef09bc2c887a6e017a00cefe"

ARG PHP_VERSION=83

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    ca-certificates \
    gnupg \
 && apk add \
    su-exec \
    dovecot \
    tini@community \
    php${PHP_VERSION}@community \
    php${PHP_VERSION}-phar@community \
    php${PHP_VERSION}-fpm@community \
    php${PHP_VERSION}-imap@community \
    php${PHP_VERSION}-pgsql@community \
    php${PHP_VERSION}-mysqli@community \
    php${PHP_VERSION}-session@community \
    php${PHP_VERSION}-mbstring@community \
 && cd /tmp \
 && PFA_TARBALL="postfixadmin-${VERSION}.tar.gz" \
 && wget -q https://github.com/postfixadmin/postfixadmin/archive/refs/tags/${PFA_TARBALL} \
 && CHECKSUM=$(sha256sum ${PFA_TARBALL} | awk '{print $1}') \
 && if [ "${CHECKSUM}" != "${SHA256_HASH}" ]; then echo "ERROR: Checksum does not match!" && exit 1; fi \
 && mkdir /postfixadmin && tar xzf ${PFA_TARBALL} -C /postfixadmin && mv /postfixadmin/postfixadmin-$VERSION/* /postfixadmin \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg /postfixadmin/postfixadmin-$VERSION*


COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
