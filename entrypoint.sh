#!/bin/bash

set -e

if [[ ! -f /etc/wireguard/wg0.conf ]]; then
    echo "WireGuard configuration file missing."
    exit 1
fi

if [[ ! -f /etc/wireguard/keys/server_private.key ]]; then
    echo "Generating server private key."
    wg genkey | tee /etc/wireguard/keys/server_private.key | wg pubkey > /etc/wireguard/keys/server_public.key
fi

if [[ ! -f /etc/wireguard/keys/client_private.key ]]; then
    echo "Generating client private key."
    wg genkey | tee /etc/wireguard/keys/client_private.key | wg pubkey > /etc/wireguard/keys/client_public.key
fi

if ! wg show &>/dev/null; then
    echo "Starting WireGuard..."
    wg-quick up wg0
fi

exec "$@"
