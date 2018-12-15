#!/bin/bash

# See:
# https://web.archive.org/web/20141112073318/https://scottlinux.com/2013/10/11/how-to-create-a-tor-onion-site/
# http://repo.or.cz/w/tails/matsa.git/blob/refs/heads/7879-http-server-with-nginx:/wiki/src/doc/advanced_topics/http_server_with_nginx.mdwn
# https://labs.riseup.net/code/issues/7879
# https://tor.stackexchange.com/questions/6055/how-to-edit-the-torrc-to-run-a-hidden-service-in-tails
# https://tor.stackexchange.com/questions/799/open-localhost8080-in-tails-to-run-hidden-service-in-tails-polipo-seems-to

TAILS_SERVER_DIR="/live/persistence/TailsData_unlocked/tails-server"

cp "$TAILS_SERVER_DIR/default" "/etc/nginx/sites-available/"
rm "/var/www/html/index.nginx-debian.html"

service nginx restart

TORRC="/etc/tor/torrc"
# Sandbox line appearing after these seems to render the service unavailable.
TORRC_L1="HiddenServiceDir /var/lib/tor/hidden_service/"
TORRC_L2="HiddenServicePort 80 127.0.0.1:8080"

[ -z "$(grep -Fx "$TORRC_L1" "$TORRC")" ] && echo "$TORRC_L1" >> "$TORRC"
[ -z "$(grep -Fx "$TORRC_L2" "$TORRC")" ] && echo "$TORRC_L2" >> "$TORRC"

service tor restart
sleep 5
service tor stop

cp "$TAILS_SERVER_DIR/hostname" "/var/lib/tor/hidden_service/"
cp "$TAILS_SERVER_DIR/private_key" "/var/lib/tor/hidden_service/"

service tor start

# Webapp using nginx as reverse proxy.
# sudo -u www-data /home/amnesia/.bin/server.sh

# Allow access to localhost through the Unsafe Browser.
#iptables -I OUTPUT -d 127.0.0.1/32 -o lo -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m owner --uid-owner debian-tor -j ACCEPT
#iptables -I OUTPUT -d 127.0.0.1/32 -o lo -p tcp --dport 8000 -j ACCEPT
#iptables -I OUTPUT -d 127.0.0.1/32 -o lo -p tcp --dport 8001 -j ACCEPT

