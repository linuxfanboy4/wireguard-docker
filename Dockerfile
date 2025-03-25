FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    wireguard \
    iproute2 \
    iputils-ping \
    curl \
    resolvconf \
    nano \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/wireguard

COPY ./wg0.conf /etc/wireguard/wg0.conf

RUN chmod 600 /etc/wireguard/wg0.conf \
    && mkdir /etc/wireguard/keys \
    && chmod 700 /etc/wireguard/keys

COPY ./scripts/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["wg-quick", "up", "wg0"]

EXPOSE 51820/udp

VOLUME ["/etc/wireguard"]

LABEL org.opencontainers.image.title="WireGuard VPN Server" \
      org.opencontainers.image.version="1.0" \
      org.opencontainers.image.description="A secure WireGuard VPN server in Docker"
