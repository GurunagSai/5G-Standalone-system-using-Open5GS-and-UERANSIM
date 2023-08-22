
#!/bin/bash
sudo ip tuntap add name ogstun mode tun
sudo ip addr add 10.45.0.1/16 dev ogstun
sudo ip addr add 2001:db8:cafe::1/48 dev ogstun
sudo ip link set ogstun up

sudo ip netns add ue1
sudo ip netns list

sleep 5s

./build/tests/app/5gc

