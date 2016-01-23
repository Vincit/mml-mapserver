FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

VOLUME "/srv/mapproxy/cache_data"
VOLUME "/srv/mapserver/data"

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    apache2 \
    libapache2-mod-wsgi \
    python-imaging \
    python-yaml \
    python-pip \
    libproj0 \
    cgi-mapserver

RUN pip install MapProxy
RUN useradd -d /srv/mapproxy mapproxy && \
    a2enmod rewrite && \
    a2disconf other-vhosts-access-log.conf && \
    mkdir -p /srv/mapproxy/www/htdocs /srv/mapproxy/cache_data /srv/mapproxy/log /srv/mapserver/data && \
    chown -R mapproxy /srv/mapproxy /srv/mapserver

ADD src/apache/apache.conf /etc/apache2/sites-available/000-default.conf

ADD src/web/proj4leaflet.js /srv/mapproxy/www/htdocs/proj4leaflet.js
ADD src/web/index.html /srv/mapproxy/www/htdocs/index.html

ADD src/mapproxy/seed.sh /srv/mapproxy/seed.sh
ADD src/mapproxy/seed.yaml /srv/mapproxy/seed.yaml
ADD src/mapproxy/log.ini /srv/mapproxy/log.ini
ADD src/mapproxy/application.py /srv/mapproxy/www/application.py
ADD src/mapproxy/mapproxy.yaml /srv/mapproxy/mapproxy.yaml
ADD src/mapserver/maastokartta.map /srv/mapserver/maastokartta.map

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
