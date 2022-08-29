#################################################################
# Dockerfile to build glpi 1.2 container images
# Based on Ubuntu 20.04
# Change for Gilmar N. Lima
#################################################################
FROM ubuntu:20.04
LABEL Gilmar N Lima <gstrtoint@gmail.com>

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
  wget \
  curl \
  dialog \
  openssh-client \
  software-properties-common \
  dnsmasq \
  dnsutils \
  net-tools \
  sudo \
  openssl \
  rsyslog \
  unzip \
  zlib1g-dev \
  apache2 \
  tzdata

RUN  DEBIAN_FRONTEND=noninteractive apt-get -y install \
  #dependências php requeridas
  php7.4 \
  php7.4-curl \
  php7.4-fileinfo \
  php7.4-gd \
  php7.4-json \
  php7.4-mbstring \
  php7.4-mysqli \

  #php7.4-session \
  #php7.4-zlib \

  php7.4-simplexml \
  php7.4-xml \
  php7.4-intl \
  php7.4-zip \
  php7.4-bz2

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
  #dependênsicas php opcional
  php7.4-cli \
  #domxml
  php7.4-ldap \
  #openssl
  php7.4-xmlrpc \
  php7.4-apcu    

RUN apt-get upgrade -y

CMD ["/usr/bin/mkdir /var/www/html/glpi"]

VOLUME ["/var/www/html/glpi"]

EXPOSE 80 443

COPY opt ./opt/ 

CMD ["/bin/bash", "/opt/glpi/glpistart.sh", "-d"]
