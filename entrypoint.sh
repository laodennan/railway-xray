#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID env required}"
WS_PATH="${WS_PATH:-/ws}"
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "$UUID", "level": 0 } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WS_PATH" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF
exec /usr/local/bin/xray run -c /etc/xray/config.json
