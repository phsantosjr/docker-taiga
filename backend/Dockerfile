FROM python:3.6-alpine3.6 as BUILDER

ARG VERSION=5.0.7

WORKDIR /srv/taiga

ENV TAIGA_VERSION 3.3.7

RUN apk update \
    && apk add --virtual build-dependencies \
    # Essentials
    gcc musl-dev libressl-dev \
    # Postgres python client (psycopg2) build dependency
    postgresql-dev \
    # Pillow / PIL build dependencies
    freetype-dev jpeg-dev libwebp-dev tiff-dev libpng-dev lcms2-dev \
    openjpeg-dev zlib-dev libxslt-dev libxml2-dev libffi-dev \
    # Other tools
    git

RUN mkdir logs \
    && git clone --depth=1 -b $VERSION https://github.com/taigaio/taiga-back.git back && cd back \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt \
    && rm -rf /root/.cache \
    && apk del .build-dependencies \
    && rm /srv/taiga/back/settings/local.py.example \
    && rm /srv/taiga/back/settings/celery.py \
    && rm /etc/nginx/conf.d/default.conf

RUN sed -i 's,git+https://github.com/Xof/django-pglocks.git,django-pglocks==1.0.2,g' requirements.txt

RUN echo "gevent==1.1.2" >> requirements.txt
RUN pip3 wheel --wheel-dir=./taiga_python_dependencies -r requirements.txt

EXPOSE 80

WORKDIR /srv/taiga/back

CMD "echo ################# starting scripts"
COPY config.py celery.py /tmp/taiga-conf/
COPY waitfordb.py /
COPY start.sh /

VOLUME ["/taiga-conf", "/taiga-media"]
CMD ["/start.sh"]