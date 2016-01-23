# WSGI module for use with Apache mod_wsgi or gunicorn

from logging.config import fileConfig
fileConfig(r'/srv/mapproxy/log.ini', {'here': '/srv/mapproxy/log'})

from mapproxy.wsgiapp import make_wsgi_app
application = make_wsgi_app(r'/srv/mapproxy/mapproxy.yaml')
