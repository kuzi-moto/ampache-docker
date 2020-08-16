#!/bin/bash

if [[ -f /var/temp/ampache.cfg.php && ! -f /var/www/config/ampache.cfg.php ]]; then
    mv /var/temp/ampache.cfg.php /var/www/config/ampache.cfg.php
fi
if [[ ! -f /var/www/config/ampache.cfg.php ]]; then
    mv /var/temp/ampache.cfg.php.dist /var/www/config/ampache.cfg.php.dist
fi

# Start apache in the background
service apache2 start

# Start cron in the background
cron

# Start a process to watch for changes in the library with inotify
(
while true; do
    inotifywatch /media
    php /var/www/bin/catalog_update.inc -a
    sleep 30
done
)

