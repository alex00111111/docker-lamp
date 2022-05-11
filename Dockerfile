FROM debian:stable-slim
MAINTAINER alex00111111 <alex00111111@protonmail.com>
LABEL Description="LAMP stack, based on latest debian-slim. Includes .htaccess support, MariaDB and PHP7." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 docker-lamp" \
	Version="1.0"

RUN apt-get update && apt-get upgrade -y &&  apt-get install -y \
	php \
	php-mysql \
	apache2 \
	libapache2-mod-php \
	mariadb-server \
	git 

RUN rm -rf /var/lib/apt/lists/*
ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb
ENV DATABASE "testdb"
ENV DATABASE_CHARSET "utf8"
ENV DATABASE_USER "reader"
ENV DATABASE_PW "testtest"
ENV GITREPO "https://github.com/banago/simple-php-website"

#only for testing, can be removed
COPY www/* /var/www/html/

#startup-script
COPY run-lamp.sh /usr/sbin/
#sql-file for DB-import
COPY setup.sql /opt/

RUN a2enmod rewrite
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["/usr/sbin/run-lamp.sh"]
