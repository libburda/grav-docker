FROM docker.io/alpine:3.12

# Define Grav specific version of Grav or use latest stable
ENV GRAV_VERSION latest

RUN apk add --no-cache \
        unzip \
        php7 \
        php7-fpm \
        php7-gd \
        php7-json \
        php7-zlib \
        php7-curl \
        php7-mbstring \
        php7-pecl-mcrypt \
        php7-intl \
        php7-zip \
        php7-session \
        php7-dom \
        php7-openssl \
        php7-xml \
        nginx \
        tini \
        cron \
    && mkdir /var/run/nginx/ \
    && mkdir /var/run/php-fpm7/ \
    && chown nginx:nginx /var/run/nginx \
    && chown nginx:nginx /var/run/php-fpm7 \
    && mkdir /var/lib/php7/session \
    && chown -R nginx:nginx /var/lib/php7 \
    && chown -R nginx:nginx /var/lib/nginx

# Set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.file_cache="/var/lib/php7/opcache/"'; \
        echo 'upload_max_filesize=128M'; \
        echo 'post_max_size=128M'; \
        echo 'expose_php=off'; \
    } > /etc/php7/conf.d/00_php-security.ini \
    && sed -i 's#^;error_log.*$#error_log = /proc/self/fd/2#' /etc/php7/php-fpm.conf \
    && sed -i 's#^;pid.*$#pid = /var/run/php-fpm7/php-fpm7.pid#' /etc/php7/php-fpm.conf \
    && sed -i 's#^;access\.log.*$#access.log = /proc/self/fd/2#' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's#^listen.*$#listen = /var/run/php-fpm7/php-fpm7.sock#' /etc/php7/php-fpm.d/www.conf

# Install grav
RUN wget -O grav-admin.zip https://getgrav.org/download/core/grav-admin/${GRAV_VERSION} \
    && unzip grav-admin.zip \
    && mv grav-admin /var/www/html \
    && chown -R nginx:nginx /var/www/html \
    && rm grav-admin.zip

COPY --chown=nginx:nginx entrypoint.sh /
COPY --chown=nginx:nginx nginx/nginx.conf nginx/common.conf /etc/nginx/
COPY --chown=nginx:nginx nginx/conf.d/* /etc/nginx/conf.d

USER nginx
WORKDIR /var/www/html

ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
