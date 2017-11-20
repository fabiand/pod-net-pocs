#!/bin/sh

set -x

# in guest
in_guest()
{
sleep 60
echo root
sleep 1
echo ifconfig eth0 up
sleep 1
echo udhcpc
sleep 2
echo "while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; date; } | nc -l -p 80; done & cat"
}


# Like slirp, just with TAP and the required additional stuff (with SLIRP it's built-in)
#
# Bridge for dhcp

ip l add name br0 type bridge
ip a add 192.168.169.254/24 dev br0
ip l set dev br0 up

# Setup dhcp
dnsmasq --strict-order --except-interface=lo --interface=br0 --listen-address=192.168.169.254 --bind-interfaces --dhcp-range=192.168.169.1,192.168.169.1 --conf-file="" -d --dhcp-host=52:54:00:12:34:44,192.168.169.1,$(hostname) &

# Allow guest -> world -- using nat
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Allow port -> quest -- using tcp proxy
cat > tcp.cfg <<EOF
defaults
  mode                    tcp
frontend main
  bind *:80
  default_backend guest
backend guest
  server guest 192.168.169.1:80 maxconn 2048
EOF
haproxy -f tcp.cfg -d &

(sleep 2 ; ip l set dev tap0 up ; ip l set dev tap0 master br0 ; ) &
in_guest | qemu-system-x86_64 -smp 4 -machine pc,accel=kvm:tcg -nographic -drive file=iscsi://iscsi-demo-target.default/iqn.2017-01.io.kubevirt:sn.42/2,copy-on-read=on -net tap,ifname=tap0,script=no,downscript=0 -net nic,macaddr=52:54:00:12:34:44

# in guest
# udhcpc
# ## dont run: ifconfig eth0 192.168.169.1 netmask 255.255.255.0 up ; ip route add default via 192.168.169.1
# while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; date; } | nc -l -p 80; done
