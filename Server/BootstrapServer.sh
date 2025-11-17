#!/bin/bash
set -e

HS_DIR="BootstrapService"
TORRC="Bootstrap.config"
mkdir -p "$HS_DIR"
sudo chmod 700 "$HS_DIR"

XMPP_PORT=2040

cat <<EOF > "$TORRC"
HiddenServiceDir $HS_DIR
HiddenServicePort 80 127.0.0.1:$XMPP_PORT
DataDirectory TorBootstrapServer
SocksPort 127.0.0.1:9875
ControlPort 127.0.0.1:9876
EOF

php -S 127.0.0.1:$XMPP_PORT &

tor -f "$TORRC" &

echo "Waiting for Tor HiddenService to initialize..."
while [ ! -f "$HS_DIR/hostname" ]; do
  sleep 1
done

ONION=$(cat "$HS_DIR/hostname" | tr -d ' \t\n')

echo $ONION > BootstrapServer.txt
