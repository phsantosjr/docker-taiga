#!/bin/bash
set -e
celery worker -A taiga worker -P gevent -c 4 --loglevel info