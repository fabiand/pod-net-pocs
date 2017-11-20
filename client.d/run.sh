#!/bin/sh

check_host() { nc $1 80 && echo " $1 OK" || echo " $1 FAIL" ; }

while sleep 2;
do
  echo Checking
  check_host qemu-slirp-date
  check_host qemu-proxy-date
  echo Done
done
