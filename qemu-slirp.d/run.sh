#!/bin/sh

set -x

# in guest
in_guest()
{
sleep 70
echo root
sleep 1
echo ifconfig eth0 up
sleep 1
echo udhcpc
sleep 2
echo "while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; hostname ; date; } | nc -l -p 80; done & cat"
}

in_guest | qemu-system-x86_64 -nographic -machine pc,accel=kvm:tcg \
--drive file=iscsi://iscsi-demo-target.default/iqn.2017-01.io.kubevirt:sn.42/2 \
-net user,hostname=$(hostname),hostfwd=tcp:0.0.0.0:80-:80 -net nic



