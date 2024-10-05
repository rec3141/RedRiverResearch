#!/bin/bash


if [ "$INSIDE_TMUX" == "true" ]; then

# The rest of the script will run inside the tmux session

####install necessary packages and set up variables

cd

sudo apt-get install -y dnsutils uuid-runtime tmux

macaddress=$(nmcli device show wlan0 | grep GENERAL.HWADDR | awk '{print $2}')

ipaddress=$(nmcli device show wlan0 | grep IP4.ADDRESS | awk '{print $2}' | cut -f1 -d'/')


#### this sets up the bird box to request a static ip address

wifi=$(nmcli device show wlan0 | grep GENERAL.CONNECTION | awk '{print $2}')

sudo nmcli connection modify $wifi ipv4.addresses ${ipaddress}/24

sudo nmcli connection modify $wifi ipv4.gateway 192.168.0.1

sudo nmcli connection modify $wifi ipv4.dns "8.8.8.8 8.8.4.4"

sudo nmcli connection modify $wifi ipv4.method manual

sudo nmcli connection down $wifi

sudo nmcli connection up $wifi


#### this sets up the bird box to host its website on the redriverresearch.ca domain

sed -i "s/BIRDNETPI_URL=$/BIRDNETPI_URL=$(hostname).${domainname}/" ~/BirdNET-Pi/birdnet.conf

curl -o dynamicdns.bash https://raw.githubusercontent.com/clempaul/dreamhost-dynamic-dns/refs/heads/master/dynamicdns.bash

chmod +x dynamicdns.bash

echo ${DREAMHOST_API_KEY}

~/dynamicdns.bash -S -v -k ${DREAMHOST_API_KEY} -r $(hostname).${domainname}

echo "@hourly ~/dynamicdns.bash -S -v -k ${DREAMHOST_API_KEY} -r $(hostname).${domainname}" > ~/.config/crontab.txt

chmod +x ~/.config/crontab.txt

crontab ~/.config/crontab.txt

echo "
$(hostname).${domainname} {
reverse_proxy $ipaddress:80
}" | sudo tee -a /etc/caddy/Caddyfile

sudo systemctl restart caddy

exit 0

fi


# Start a tmux session and set the environment variable inside it
tmux new-session -d -s mysession bash -c "INSIDE_TMUX=true ./birdbox-remotesetup.sh"

# Attach to the session (optional)
tmux attach-session -t mysession


macaddress=$(nmcli device show wlan0 | grep GENERAL.HWADDR | awk '{print $2}')

echo "MAC ADDRESS: $macaddress"

ipaddress=$(nmcli device show wlan0 | grep IP4.ADDRESS | awk '{print $2}' | cut -f1 -d'/')

echo "IP ADDRESS: $ipaddress"



