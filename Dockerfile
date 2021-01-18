FROM docker.io/nginx:1.18-alpine

ENV NGINX_PORT=8081

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "sh", "-c", "nc -nz localhost ${NGINX_PORT}" ]

COPY default.conf.template /etc/nginx/templates/default.conf.template
COPY src /usr/share/nginx/html
