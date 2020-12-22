#!/bin/sh

php-fpm7 -F &

#rm -f /usr/local/apache2/logs/httpd.pid

nginx -g 'daemon off;'
#httpd -DFOREGROUND
