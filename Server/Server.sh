#!/bin/bash

export SERVER_PID=$$
echo $SERVER_PID > SERVER_PID.txt 

HS_DIR="Service/"
TORRC=".config"
mkdir -p "$HS_DIR"
sudo chmod 700 "$HS_DIR"

XMPP_PORT=32767

cat <<EOF > "$TORRC"
HiddenServiceDir $HS_DIR
HiddenServicePort 80 127.0.0.1:$XMPP_PORT
DataDirectory TorServer
SocksPort 127.0.0.1:9999
ControlPort 127.0.0.1:9998
EOF

tor -f "$TORRC" &
TOR_PID=$!

echo "Waiting for Tor HiddenService to initialize..."
while [ ! -f "$HS_DIR/hostname" ]; do
  sleep 1
done

ONION=$(cat "$HS_DIR/hostname" | tr -d ' \t\n')


mkdir -p certs

openssl req -newkey rsa:2048 -nodes -keyout ./certs/onion.key -x509 -days 365 -out ./certs/onion.crt -subj "/CN=$ONION"

cat <<EOF > prosody.cfg.lua
admins = {}
modules_enabled = {
    "roster"; "saslauth"; "tls"; "dialback"; "disco"; "carbons"; "pep"; "private"; "blocklist"; "vcard"; "version"; "uptime"; "time"; "ping"; "register"; "admin_adhoc";
};
allow_registration = true
interfaces = { "127.0.0.1" }
c2s_ports = { $XMPP_PORT }
allow_anonymous_s2s = true
VirtualHost "$ONION"
    enabled = true
    authentication = "anonymous"
    ssl = {
        key = "./certs/onion.key";
        certificate = "./certs/onion.crt";
    }

EOF

echo "Written Prosody config to prosody.cfg.lua"

prosody --config ./prosody.cfg.lua -F &

echo $ONION > Address.txt
