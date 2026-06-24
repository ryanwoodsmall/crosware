#!/usr/bin/env bash

set -eu

sudo initctl stop bluetoothd || true
btmods=( $(lsmod | grep -E '^(bt|bluetooth|rfcomm)' | awk '{print $NF}' | tr ',' '\n' | grep -E '^(b|r)') )
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
