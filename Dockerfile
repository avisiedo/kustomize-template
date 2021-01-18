FROM docker.io/nginx:1.19.6-alpine

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "sh", "-c", "cat > /dev/tcp/localhost/80 < /dev/null" ]

COPY src /usr/share/nginx/html
