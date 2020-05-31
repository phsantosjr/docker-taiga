FROM python:3.6

ENV TAIGA_VERSION 5.0.7

WORKDIR /srv/taiga

RUN apt-get update && apt-get install gcc python-dev -y
RUN pip3 install --upgrade pip

ADD https://github.com/taigaio/taiga-back/archive/${TAIGA_VERSION}.tar.gz ./
    RUN tar -xzf ${TAIGA_VERSION}.tar.gz -C ./ taiga-back-${TAIGA_VERSION} --strip-components=1
RUN rm ${TAIGA_VERSION}.tar.gz

# Don't want pip to use git, so I'm replacing with pypi.
RUN sed -i 's,git+https://github.com/Xof/django-pglocks.git,django-pglocks==1.0.2,g' requirements.txt

# local.py and checkdb.py and celery
# using gevent to run taiga gunicorn (workers)
# using gevent on celery (workers)
RUN echo "django-environ==0.4.0" >> requirements.txt
RUN echo "gevent==20.5.2" >> requirements.txt
RUN echo "django-anymail==0.5" >> requirements.txt

RUN pip3 install -r requirements.txt

EXPOSE 80

WORKDIR /srv/taiga/back

COPY config.py celery.py /tmp/taiga-conf/
COPY waitfordb.py /
COPY start.sh /

VOLUME ["/taiga-conf", "/taiga-media"]
CMD ["/start.sh"]

