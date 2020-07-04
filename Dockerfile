FROM composer:1.10.8 AS Builder

ADD https://github.com/ampache/ampache/archive/master.tar.gz /tmp
RUN     tar -xzf /tmp/master.tar.gz --strip=1 -C . \
    &&  composer install --prefer-source --no-interaction \
    &&  rm -rf .git* .php_cs .sc .scrutinizer.yml .tgitconfig .travis.yml .tx *.md \
    &&  mv ./rest/.htac* ./rest/.htaccess \
    &&  mv ./play/.htac* ./play/.htaccess \
    &&  mv ./channel/.htac* ./channel/.htaccess \
    &&  chmod -R 775 .


FROM ubuntu:18.04
LABEL maintainer="lachlan-00"

ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_PASS **Random**

COPY create_mysql_admin_user.sh run.sh /
COPY 001-ampache.conf /etc/apache2/sites-available/
COPY ampache.cfg.* /var/temp/

RUN     apt-get update \
    &&  apt-get -qq install --no-install-recommends \
          apache2 \
          cron \
          ffmpeg \
          flac \
          inotify-tools \
          lame \
          libavcodec-extra \
          libev-libevent-dev \
          libfaac-dev \
          libmp3lame-dev \
          libtheora-dev \
          libvorbis-dev \
          libvpx-dev \
          mysql-server \
          php \
          php-curl \
          php-gd \
          php-json \
          php-mysql \
          php-xml \
          pwgen \
          vorbis-tools \
    &&  rm -rf /var/lib/mysql/* /var/www/* /etc/apache2/sites-enabled/* \
    &&  mkdir -p /var/run/mysqld \
    &&  chown -R mysql /var/run/mysqld \
    &&  chmod 0775 /*.sh \
    &&  ln -s /etc/apache2/sites-available/001-ampache.conf /etc/apache2/sites-enabled/ \
    &&  a2enmod rewrite \
    &&  rm -rf /var/cache/* /tmp/* /var/tmp/* /root/.cache \
    &&  echo '30 7 * * *   /usr/bin/php /var/www/bin/catalog_update.inc' | crontab -u www-data -

COPY --from=Builder --chown=www-data:www-data /app /var/www

VOLUME ["/etc/mysql", "/var/lib/mysql", "/media", "/var/www/config", "/var/www/themes"]
EXPOSE 80

CMD ["/run.sh"]