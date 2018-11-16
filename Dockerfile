FROM alpine
LABEL maintainer="lomocc <constlomo@gmail.com>"

ARG SHADOWSOCKS_LIBEV_RELEASE_URL="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.2.0/shadowsocks-libev-3.2.0.tar.gz"

RUN set -ex \
    # Build environment setup
    && apk add --no-cache --virtual .build-deps \
    autoconf \
    automake \
    build-base \
    openssl \
    c-ares-dev \
    libev-dev \
    libtool \
    libsodium-dev \
    linux-headers \
    mbedtls-dev \
    pcre-dev \
    && cd /tmp \
    # polipo
    && wget https://github.com/jech/polipo/archive/master.zip -O polipo.zip \
    && unzip polipo.zip \
    && cd polipo-master \
    && make \
    && install polipo /usr/local/bin/ \
    && cd .. \
    && rm -rf polipo.zip polipo-master \
    && mkdir -p /usr/share/polipo/www /var/cache/polipo \
    # shadowsocks
    && wget -O shadowsocks-libev.tar.gz $SHADOWSOCKS_LIBEV_RELEASE_URL && mkdir shadowsocks-libev \
    && tar -xvf shadowsocks-libev.tar.gz -C shadowsocks-libev --strip-components 1 \
    && cd shadowsocks-libev \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && apk del .build-deps build-base openssl \
    # Runtime dependencies setup
    && apk add --no-cache \
    rng-tools \
    $(scanelf --needed --nobanner /usr/bin/ss-* \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u) \
    && rm -rf /tmp/*

ENV SERVER      127.0.0.1
ENV PORT        8388
ENV METHOD      aes-256-gcm
ENV PASSWORD	123456
ENV TIMEOUT     300

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]