FROM python:3.6

ARG TAIGA_VERSION=5.0.7

RUN apt-get update
RUN apt-get install gcc python-dev git gettext -y
RUN pip3 install --upgrade pip

#RUN echo " ## Downloading Taiga for Github"
#ADD https://github.com/taigaio/taiga-back/archive/$TAIGA_VERSION.tar.gz .
#RUN tar -xzf $TAIGA_VERSION.tar.gz -C ./ taiga-back-$TAIGA_VERSION --strip-components=1
#RUN ls
#RUN rm $TAIGA_VERSION.tar.gz

# Don't want pip to use git, so I'm replacing with pypi.
#RUN sed -i 's,git+https://github.com/Xof/django-pglocks.git,django-pglocks==1.0.2,g' requirements.txt

# local.py and checkdb.py and celery
# using gevent to run taiga gunicorn (workers)
# using gevent on celery (workers)
#RUN echo "django-environ==0.4.0" >> requirements.txt
#RUN echo "gevent==1.1.2" >> requirements.txt
#RUN echo "django-anymail==0.5" >> requirements.txt

RUN pip3 install django-environ==0.4.0 gevent==1.1.2 django-anymail==0.5

ADD . /

# FINAL IMAGE
RUN pip3 install -r requirements.txt

RUN export C_FORCE_ROOT='true'

COPY local.py settings/local.py
COPY celery_local.py settings/celery_local.py
COPY scripts/ /scripts/

RUN chmod +x /scripts/entrypoint.sh