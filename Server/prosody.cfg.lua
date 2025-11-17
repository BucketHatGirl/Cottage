admins = {}
modules_enabled = {
    "roster"; "saslauth"; "tls"; "dialback"; "disco"; "carbons"; "pep"; "private"; "blocklist"; "vcard"; "version"; "uptime"; "time"; "ping"; "register"; "admin_adhoc";
};
allow_registration = true
interfaces = { "127.0.0.1" }
c2s_ports = { 32767 }
allow_anonymous_s2s = true
VirtualHost "tjb36whvjncweohhgvtg2udvqnnxg3imtxapocs44twhqpvccs7orcqd.onion"
    enabled = true
    authentication = "anonymous"
    ssl = {
        key = "./certs/onion.key";
        certificate = "./certs/onion.crt";
    }

