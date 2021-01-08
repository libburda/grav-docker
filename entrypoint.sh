#!/bin/sh

# Check if persistent volume is mounted
if [ -d "$PERSISTENT_DIR" ]; then
    echo "$0: $PERSISTENT_DIR exists"
    # If persistent directory is empty, copy default content to it
    if [ ! -d "$PERSISTENT_DIR/accounts" ]; then
        echo "$0: Copying default user dir to $PERSISTENT_DIR"
        cp -r /var/www/html/user/* "$PERSISTENT_DIR"
    fi
    # Link persistent directory to /var/www/html/user
    echo "$0: Linking $PERSISTENT_DIR to /var/www/html/user"
    rm -r /var/www/html/user
    ln -sf "$PERSISTENT_DIR" /var/www/html/user
fi

php-fpm7 -F &

exec nginx -g 'daemon off;'
