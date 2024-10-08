FROM --platform=$TARGETPLATFORM caddy:alpine AS builder

RUN apk add --no-cache curl

RUN curl -fSL https://raw.githubusercontent.com/wy2919/mirror-proxy/master/Caddyfile -o /etc/caddy/Caddyfile

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
