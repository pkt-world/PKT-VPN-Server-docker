#!/bin/bash
# Script to build and run docker container
# and print out the VPN exit info
echo "Building docker image PKT-Server..."
docker build -t pkt-server .
echo "Please enter your secret key:"
read secret
echo "Running docker container PKT-Server..."
echo "Provide a name for your VPN Exit and country of exit"
echo "VPN Name: "
read name
echo "Country: "
read country

docker run -d --rm \
        --cap-add=NET_ADMIN \
        --device /dev/net/tun:/dev/net/tun \
        --sysctl net.ipv6.conf.all.disable_ipv6=0 \
        --sysctl net.ipv4.ip_forward=1 \
        -p 47512:47512/udp -p 8099:8099 \
        -e PKTEER_SECRET=$secret \
        -e PKTEER_NAME=$name \
        -e PKTEER_COUNTRY=$country \
        --name pkt-server pkt-server

docker exec -e PKTEER_SECRET=$secret pkt-server /server/init.sh
docker exec -e PKTEER_NAME=$name -e PKTEER_COUNTRY=$country pkt-server /server/vpn_info.sh
