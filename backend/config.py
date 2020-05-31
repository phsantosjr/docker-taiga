from .common import *

PUBLIC_REGISTER_ENABLED = False
DEBUG = False
TEMPLATE_DEBUG = False

SECRET_KEY = '$TAIGA_SECRET'

MEDIA_URL = "http://$TAIGA_HOST/media/"
STATIC_URL = "http://$TAIGA_HOST/static/"
ADMIN_MEDIA_PREFIX = "http://$TAIGA_HOST/static/admin/"
SITES["api"]["scheme"] = "http"
SITES["api"]["domain"] = "$TAIGA_HOST"
SITES["front"]["scheme"] = "http"
SITES["front"]["domain"] = "$TAIGA_HOST"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "$POSTGRES_DB",
        "HOST": "$POSTGRES_HOST",
        "USER": "$POSTGRES_USER",
        "PASSWORD": "$POSTGRES_PASSWORD"
    }
}

#DEFAULT_FROM_EMAIL = "john@doe.com"
#CHANGE_NOTIFICATIONS_MIN_INTERVAL = 300 #seconds
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
#EMAIL_USE_TLS = False
#EMAIL_USE_SSL = False # You cannot use both (TLS and SSL) at the same time!
#EMAIL_HOST = 'localhost'
#EMAIL_PORT = 25
#EMAIL_HOST_USER = 'user'
#EMAIL_HOST_PASSWORD = 'password'

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": "amqp://$RABBITMQ_DEFAULT_USER:$RABBIT_DEFAULT_PASS@$RABBIT_HOST:$RABBIT_PORT/$RABBIT_DEFAULT_VHOST"}

CELERY_ENABLED = True
