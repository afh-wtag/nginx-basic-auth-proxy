#!/bin/sh

set -e

echo >&2 "Start running script"

if [ -z $BASIC_AUTH_USERNAME ]; then
  echo >&2 "BASIC_AUTH_USERNAME must be set"
  exit 1
fi

if [ -z $BASIC_AUTH_PASSWORD ]; then
  echo >&2 "BASIC_AUTH_PASSWORD must be set"
  exit 1
fi

if [ -z $PROXY_PASS ]; then
  echo >&2 "PROXY_PASS must be set"
  exit 1
fi

if [ -z $RESTRICTED_END_POINT ]; then
  echo >&2 "RESTRICTED_END_POINT must be set"
  exit 1
fi

if [ -z $HEALTH_CHECK_END_POINT ]; then
  echo >&2 "HEALTH_CHECK_END_POINT must be set"
  exit 1
fi

echo >&2 "End running script"
echo >&2 "BASIC_AUTH_USERNAME $BASIC_AUTH_USERNAME, BASIC_AUTH_PASSWORD $BASIC_AUTH_PASSWORD"
echo >&2 "PROXY_PASS $PROXY_PASS, RESTRICTED_END_POINT $RESTRICTED_END_POINT, HEALTH_CHECK_END_POINT $HEALTH_CHECK_END_POINT"

htpasswd -bBc /etc/nginx/.htpasswd $BASIC_AUTH_USERNAME $BASIC_AUTH_PASSWORD
sed \
  -e "s/##CLIENT_MAX_BODY_SIZE##/$CLIENT_MAX_BODY_SIZE/g" \
  -e "s/##PROXY_READ_TIMEOUT##/$PROXY_READ_TIMEOUT/g" \
  -e "s/##WORKER_PROCESSES##/$WORKER_PROCESSES/g" \
  -e "s/##BACKEND_SERVER_NAME##/$BACKEND_SERVER_NAME/g" \
  -e "s/##BACKEND_PORT##/$BACKEND_PORT/g" \
  -e "s|##PROXY_PASS##|$PROXY_PASS|g" \
  -e "s|##RESTRICTED_END_POINT##|$RESTRICTED_END_POINT|g" \
  -e "s|##HEALTH_CHECK_END_POINT##|$HEALTH_CHECK_END_POINT|g" \
  nginx.conf.tmpl > /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
