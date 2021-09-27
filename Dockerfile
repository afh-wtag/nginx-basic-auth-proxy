FROM nginx:1.11.9-alpine
# FROM nginx:1.21-alpine

# for htpasswd command
RUN apk add --no-cache --update \
      apache2-utils vim
RUN rm -f /etc/nginx/conf.d/*

ENV BACKEND_SERVER_NAME example.com
ENV BACKEND_PORT 80
ENV CLIENT_MAX_BODY_SIZE 1m
ENV PROXY_READ_TIMEOUT 60s
ENV WORKER_PROCESSES auto
ENV HEALTH_CHECK_END_POINT /health

COPY files/run.sh /
COPY files/nginx.conf.tmpl /

RUN chmod +x /run.sh

# use SIGQUIT for graceful shutdown
# c.f. http://nginx.org/en/docs/control.html
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/run.sh"]
