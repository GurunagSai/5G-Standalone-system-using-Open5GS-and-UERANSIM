
#!bin/bash

sudo sysctl -w net.ipv4.ip_forward=1

sudo ip addr add 10.0.2.45/16 dev enp0s3

sudo ip tuntap add name ogstun3 mode tun
sudo ip addr add 10.55.0.1/16 dev ogstun3
sudo ip link set ogstun3 up

sudo iptables -t nat -A POSTROUTING -s 10.55.0.0/16 ! -o ogstun3 -j MASQUERADE

sudo ip tuntap add name ogstun4 mode tun
sudo ip addr add 10.56.0.1/16 dev ogstun4
sudo ip link set ogstun4 up

sudo iptables -t nat -A POSTROUTING -s 10.56.0.0/16 ! -o ogstun4 -j MASQUERADE

sudo systemctl stop open5gs-nrfd
sudo systemctl stop open5gs-scpd
sudo systemctl stop open5gs-smfd
sudo systemctl stop open5gs-amfd
sudo systemctl stop open5gs-ausfd
sudo systemctl stop open5gs-udmd
sudo systemctl stop open5gs-udrd
sudo systemctl stop open5gs-pcfd
sudo systemctl stop open5gs-nssfd
sudo systemctl stop open5gs-bsfd
sleep 5
sudo systemctl restart open5gs-upfd
sleep 5
sudo systemctl status open5gs-upfd
