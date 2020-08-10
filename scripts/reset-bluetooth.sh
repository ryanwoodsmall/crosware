#!/usr/bin/env bash

set -eu

sudo initctl stop bluetoothd || true
btmods=( $(lsmod | egrep '^(bt|bluetooth|rfcomm)' | awk '{print $NF}' | tr ',' '\n' | egrep '^(b|r)') )
for btmod in ${btmods[@]} ; do
  echo "rmmod ${btmod}"
  sudo rmmod ${btmod} || true
done
sudo modprobe rfcomm
sudo modprobe bluetooth
for btmod in ${btmods[@]} ; do
  echo "modprobe ${btmod}"
  sudo modprobe ${btmod}
done
sudo initctl start bluetoothd
