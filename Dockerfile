FROM ubuntu
MAINTAINER DOCOSRE-Team <sre@docotel.com>


RUN apt-get update -y
RUN apt-get dist-upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential dnsutils imagemagick libpcre3 libpcre3-dev libssl-dev php5.6-curl php5.6-mbstring php5.6-gd php5.6-fpm php5.6-imagick php5.6-mcrypt php5.6-memcache php5.6-memcached php5.6-mysql ssmtp supervisor zlib1g-dev wget whois

RUN wget http://nginx.org/keys/nginx_signing.key
RUN apt-key add nginx_signing.key
RUN echo "deb http://nginx.org/packages/debian/ codename nginx" >> /etc/apt/source.list
RUN echo "deb-src http://nginx.org/packages/debian/ codename nginx" >> /etc/apt/source.list
RUN apt-get update -y
RUN apt-get install nginx -y
RUN apt-get install net-tools -y && apt-get install nano -y

RUN mkdir -p /var/lib/nginx /etc/nginx/sites-enabled /etc/nginx/sites-available /var/www

ADD nginx.conf /etc/nginx/nginx.conf
ADD www.conf /etc/php/5.6/fpm/pool.d/www.conf
ADD default /etc/nginx/sites-available/default
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD php-fpm.conf /etc/php/5.6/fpm/php-fpm.conf

RUN rm -rf /var/lib/apt/lists/* &&\
    rm -rf /usr/share/man/?? &&\
    rm -rf /usr/share/man/??_*

RUN mkdir -p /var/www/html/
RUN chown -R www-data: /var/www/html/
WORKDIR /var/www/html

COPY pi.php /var/www/html/

EXPOSE 80

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
