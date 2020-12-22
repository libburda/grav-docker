#!/bin/sh

php-fpm7 -F &

exec nginx -g 'daemon off;'
