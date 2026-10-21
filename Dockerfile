FROM docker.io/oven/bun:1.4.0-alpine@sha256:07235578f79ef8c6f97d94aee7938e76f5cdba5f21ae5dbfdd3d3d38058437eb AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile
COPY . .
RUN bun run build

FROM docker.io/rtsp/lighttpd:1.4.82@sha256:2e670b313a1ed925f5d3ad31d64bc8eb12703d5b7dc72769ca54de1c5e354b51

LABEL org.opencontainers.image.source="https://github.com/aNNdii/unduckified"

COPY --from=build /app/dist/ /var/www/html/
COPY lighttpd.conf /etc/lighttpd/conf.d/20-unduck.conf
RUN /usr/sbin/lighttpd -tt -f /etc/lighttpd/lighttpd.conf
