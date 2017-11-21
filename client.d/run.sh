#!/bin/sh

check_host() { curl -s $1 | grep ping && echo " $1 OK" || echo " $1 FAIL" ; }

while sleep 2;
do
  echo Checking
  check_host qemu-slirp-date
  check_host qemu-proxy-date
  check_host qemu-dnat-date
  echo Done
done
