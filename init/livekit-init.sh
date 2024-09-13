#!/bin/sh

cat << EOF > /livekit.yaml
---
port: $LIVEKIT_HTTP_PORT
bind_addresses:
    - "$LIVEKIT_HTTP_BIND_ADDRESS"
rtc:
    tcp_port: $LIVEKIT_TCP_PORT
    port_range_start: $LIVEKIT_RTC_PORT_RANGE_START
    port_range_end: $LIVEKIT_RTC_PORT_RANGE_END
    use_external_ip: $LIVEKIT_RTC_USE_EXTERNAL_IP
    enable_loopback_candidate: $LIVEKIT_RTC_ENABLE_LOOPBACK_CANDIDATE
redis:
    address: "$LIVEKIT_REDIS_ADDRESS"
    username: "$LIVEKIT_REDIS_USERNAME"
    password: "$LIVEKIT_REDIS_PASSWORD"
    db: $LIVEKIT_REDIS_DB
    use_tls: $LIVEKIT_REDIS_USE_TLS
    sentinel_master_name: "$LIVEKIT_REDIS_SENTINEL_MASTER_NAME"
    sentinel_username: "$LIVEKIT_REDIS_SENTINEL_USERNAME"
    sentinel_password: "$LIVEKIT_REDIS_SENTINEL_PASSWORD"
    sentinel_addresses: $LIVEKIT_REDIS_SENTINEL_ADDRESSES
    cluster_addresses: $LIVEKIT_REDIS_CLUSTER_ADDRESSES
    max_redirects: $LIVEKIT_REDIS_MAX_REDIRECTS
turn: 
    enabled: $LIVEKIT_TURN_ENABLED
    domain: "$LIVEKIT_TURN_DOMAIN"
    tls_port: $LIVEKIT_TURN_TLS_PORT
    udp_port: $LIVEKIT_TURN_UDP_PORT
    external_tls: $LIVEKIT_TURN_EXTERNAL_TLS
keys:
    $LIVEKIT_KEYS_API_KEY: $LIVEKIT_KEYS_API_SECRET
logging:
    json: $LIVEKIT_LOGGING_JSON
    level: $LIVEKIT_LOGGING_LEVEL
EOF

/livekit-server --config /livekit.yaml

