FROM ubuntu:12.10

RUN echo "Asia/Tokyo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install perl
RUN apt-get -y install libpg-perl
RUN apt-get -y install libdbd-pg-perl
RUN apt-get -y install libfile-find-rule-perl
RUN apt-get -y install libdigest-sha-perl
RUN apt-get -y install libarchive-zip-perl

RUN apt-get -y install apache2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
# ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOG_DIR /log


RUN ln -s /etc/apache2/mods-available/userdir.load /etc/apache2/mods-enabled/userdir.load
RUN ln -s /etc/apache2/mods-available/userdir.conf /etc/apache2/mods-enabled/userdir.conf
RUN ln -s /etc/apache2/mods-available/auth_digest.load /etc/apache2/mods-enabled/auth_digest.load
RUN echo 'AddHandler cgi-script .cgi' >> /etc/apache2/apache2.conf

RUN sed -i -e 's/Options/Options ExecCGI/' /etc/apache2/mods-enabled/userdir.conf

ADD apache2.conf /etc/apache2/conf.d/

RUN mkdir /var/run/apache2

ADD pyukiwiki-0.1.6-devel.tar.gz /var/www
RUN mv /var/www/pyukiwiki-0.1.6-devel /var/www/wiki
RUN echo 'Options ExecCGI' >> /var/www/wiki/.htaccess

RUN chown -R www-data:www-data /var/www/wiki

RUN ls -l /var/www/wiki

EXPOSE 80
VOLUME /log

# RUN cat /etc/apache2/apache2.conf # | grep Options
RUN cat /etc/apache2/mods-enabled/userdir.conf

# CMD service apache2 start
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
