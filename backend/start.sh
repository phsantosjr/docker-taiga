#!/bin/sh

echo '....initializing start.sh #####'

cd /srv/taiga/back

INITIAL_SETUP_LOCK=/taiga-conf/.initial_setup.lock
if [ ! -f $INITIAL_SETUP_LOCK ]; then
    touch $INITIAL_SETUP_LOCK

    sed -e 's/$TAIGA_HOST/'$TAIGA_HOST'/' \
        -e 's/$TAIGA_SECRET/'$TAIGA_SECRET'/' \
        -e 's/$TAIGA_SCHEME/'$TAIGA_SCHEME'/' \
        -e 's/$POSTGRES_HOST/'$POSTGRES_HOST'/' \
        -e 's/$POSTGRES_DB/'$POSTGRES_DB'/' \
        -e 's/$POSTGRES_USER/'$POSTGRES_USER'/' \
        -e 's/$POSTGRES_PASSWORD/'$POSTGRES_PASSWORD'/' \
        -e 's/$RABBIT_HOST/'$RABBIT_HOST'/' \
        -e 's/$RABBIT_PORT/'$RABBIT_PORT'/' \
        -e 's/$RABBIT_USER/'$RABBITMQ_DEFAULT_USER'/' \
        -e 's/$RABBIT_PASSWORD/'$RABBIT_DEFAULT_PASS'/' \
        -e 's/$RABBIT_VHOST/'$RABBIT_DEFAULT_VHOST'/' \
        -i /tmp/taiga-conf/config.py
    cp /tmp/taiga-conf/config.py /taiga-conf/
    ln -sf /taiga-conf/config.py /srv/taiga/back/settings/local.py

    sed -e 's/$RABBIT_HOST/'$RABBIT_HOST'/' \
        -e 's/$RABBIT_PORT/'$RABBIT_PORT'/' \
        -e 's/$RABBIT_USER/'$RABBITMQ_DEFAULT_USER'/' \
        -e 's/$RABBIT_PASSWORD/'$RABBIT_DEFAULT_PASS'/' \
        -e 's/$RABBIT_VHOST/'$RABBIT_DEFAULT_VHOST'/' \
        -e 's/$REDIS_HOST/'$REDIS_HOST'/' \
        -e 's/$REDIS_PORT/'$REDIS_PORT'/' \
        -e 's/$REDIS_DB/'$REDIS_DB'/' \
        -e 's/$REDIS_PASSWORD/'$REDIS_PASSWORD'/' \
        -i /tmp/taiga-conf/celery.py
    cp /tmp/taiga-conf/celery.py /taiga-conf/
    ln -sf /taiga-conf/celery.py /srv/taiga/back/settings/celery.py

    ln -sf /taiga-media /srv/taiga/back/media

    echo 'Waiting for database to become ready...'
    python3 /waitfordb.py
    echo 'Running initial setup...'
    python3 manage.py migrate --noinput
    python3 manage.py loaddata initial_user
    python3 manage.py loaddata initial_project_templates
    python3 manage.py compilemessages
    python3 manage.py collectstatic --noinput
else
    ln -sf /taiga-conf/config.py /srv/taiga/back/settings/local.py
    ln -sf /taiga-conf/celery.py /srv/taiga/back/settings/celery.py
    ln -sf /taiga-media /srv/taiga/back/media

    echo 'Waiting for database to become ready...'
    python3 /waitfordb.py
    echo 'Running database update...'
    python3 manage.py migrate --noinput
    python3 manage.py compilemessages
    python3 manage.py collectstatic --noinput

    echo 'Installing cron jobs...'
    echo '*/5 * * * * cd /srv/taiga/back && /usr/bin/python3 manage.py send_notifications >> /var/log/cron 2>&1' > /etc/crontabs/root
fi

C_FORCE_ROOT=1 celery -A taiga worker --concurrency 4 -l INFO &
CELERY_PID=$!

gunicorn --workers 4 --timeout 60 -b 127.0.0.1:8000 taiga.wsgi > /dev/stdout 2> /dev/stderr &
TAIGA_PID=$!

#mkdir /run/nginx
#nginx -g 'daemon off;' &
#NGINX_PID=$!

crond >> /var/log/crond 2>&1

trap 'kill -TERM $TAIGA_PID; kill -TERM $CELERY_PID' SIGTERM

wait $TAIGA_PID $CELERY_PID