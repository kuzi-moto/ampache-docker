FROM debian:stable
LABEL maintainer="lachlan-00"

ENV DEBIAN_FRONTEND=noninteractive

ADD run.sh /usr/local/bin/
ADD 001-ampache.conf /etc/apache2/sites-available/
COPY ampache.cfg.* /var/temp/

RUN     chmod 0755 /usr/local/bin/run.sh \
    &&  chmod +x /usr/local/bin/run.sh
RUN     apt-get -q -q update
RUN     apt-get -q -q -y install --no-install-recommends wget gnupg ca-certificates
RUN     apt-get -q -q -y install --no-install-recommends software-properties-common
RUN     apt-add-repository contrib \
    &&  apt-add-repository non-free
RUN     apt-get -q -q update \
    &&  apt-get -q -q -y install --no-install-recommends libdvd-pkg
RUN     dpkg-reconfigure libdvd-pkg
RUN     apt-get -q -q update \
    &&  apt-get -q -q -y upgrade --no-install-recommends
RUN     apt-get -q -q -y install --no-install-recommends \
          inotify-tools apache2 php php-json php-intl \
          php-curl php-mysql php-gd php-xml composer libev-libevent-dev \
          lame libvorbis-dev vorbis-tools flac \
          libmp3lame-dev libfaac-dev libtheora-dev libvpx-dev \
          libavcodec-extra ffmpeg git cron
RUN     rm -rf /var/www/* /etc/apache2/sites-enabled/* \
    &&  wget -qO - https://github.com/ampache/ampache/archive/master.tar.gz \
          | tar -C /var/www -xzf - ampache-master --strip=1 \
    &&  mv /var/www/rest/.htac* /var/www/rest/.htaccess \
    &&  mv /var/www/play/.htac* /var/www/play/.htaccess \
    &&  mv /var/www/channel/.htac* /var/www/channel/.htaccess
RUN     chown -R www-data:www-data /var/www \
    &&  chmod -R 775 /var/www
RUN     su -s /bin/sh -c 'cd /var/www && composer install --prefer-source --no-interaction' www-data
RUN     apt-get purge -q -q -y --autoremove git wget ca-certificates gnupg composer software-properties-common
RUN     ln -s /etc/apache2/sites-available/001-ampache.conf /etc/apache2/sites-enabled/ \
    &&  a2enmod rewrite
RUN     rm -rf /var/cache/* /tmp/* /var/tmp/* /root/.cache /var/www/.composer \
    &&  find /var/www -type d -name '.git' -print0 | xargs -0 -L1 -- rm -rf \
    &&  echo '30 7 * * *   /usr/bin/php /var/www/bin/catalog_update.inc' | crontab -u www-data -

VOLUME ["/media", "/var/www/config", "/var/www/themes"]
EXPOSE 80

CMD ["/usr/local/bin/run.sh"]
