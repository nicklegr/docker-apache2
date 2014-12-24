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

RUN useradd --uid 1000 --gid 50 apache
RUN sed -i -e 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=apache/g' /etc/apache2/envvars
RUN sed -i -e 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=staff/g' /etc/apache2/envvars

RUN ln -s /etc/apache2/mods-available/userdir.load /etc/apache2/mods-enabled/userdir.load
RUN ln -s /etc/apache2/mods-available/userdir.conf /etc/apache2/mods-enabled/userdir.conf
RUN ln -s /etc/apache2/mods-available/auth_digest.load /etc/apache2/mods-enabled/auth_digest.load

RUN sed -i -e 's/Options/Options ExecCGI/' /etc/apache2/mods-enabled/userdir.conf

ADD sites-default /etc/apache2/conf.d/sites-available/default

RUN mkdir /var/run/apache2

VOLUME /var/www

EXPOSE 80

# RUN cat /etc/apache2/apache2.conf # | grep Options
RUN cat /etc/apache2/mods-enabled/userdir.conf

ADD run.sh /tmp/run.sh
RUN chmod 755 /tmp/run.sh

# CMD service apache2 start
CMD ["/tmp/run.sh"]
