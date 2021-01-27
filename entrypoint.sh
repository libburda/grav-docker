#!/bin/sh

if [ ! "$(ls "/var/www/html")" ]; then
    # Install grav
    echo "$0: Installing grav"
    cd /tmp \
        && wget -O grav-admin.zip https://getgrav.org/download/core/grav-admin/${GRAV_VERSION} \
        && unzip -q grav-admin.zip \
        && mv grav-admin/* /var/www/html \
        && rm grav-admin.zip
fi

php-fpm7 -F &

exec nginx -g 'daemon off;'
