#!/bin/sh

if [ -f /livekit.yaml ]; then
  echo "[INIT] livekit.yaml config present. Skip writing config."
else
  echo "[INIT] Write livekit.yaml."
cat << EOF > /livekit.yaml
---
port: $LIVEKIT_HTTP_PORT
rtc:
    tcp_port: $LIVEKIT_TCP_PORT
    port_range_start: $LIVEKIT_RTC_PORT_RANGE_START
    port_range_end: $LIVEKIT_RTC_PORT_RANGE_END
    use_external_ip: $LIVEKIT_RTC_USE_EXTERNAL_IP
    enable_loopback_candidate: $LIVEKIT_RTC_ENABLE_LOOPBACK_CANDIDATE
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
fi

echo "Print /livekit.yaml"
cat /livekit.yaml


/livekit-server --config /livekit.yaml
