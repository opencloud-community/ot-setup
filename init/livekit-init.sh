#!/bin/sh

cat << EOF > /livekit.yaml
---
port: $LIVEKIT_HTTP_PORT
rtc:
  use_external_ip: $LIVEKIT_RTC_USE_EXTERNAL_IP
  tcp_port: $LIVEKIT_TCP_PORT
  port_range_start: $LIVEKIT_RTC_PORT_RANGE_START
  port_range_end: $LIVEKIT_RTC_PORT_RANGE_END
  enable_loopback_candidate: $LIVEKIT_RTC_ENABLE_LOOPBACK_CANDIDATE
turn: 
  enabled: $LIVEKIT_TURN_ENABLED
keys:
  $LIVEKIT_KEYS_API_KEY: $LIVEKIT_KEYS_API_SECRET
logging:
  json: $LIVEKIT_LOGGING_JSON
  level: $LIVEKIT_LOGGING_LEVEL
EOF

/livekit-server --config /livekit.yaml

