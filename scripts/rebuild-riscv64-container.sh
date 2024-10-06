#!/usr/bin/env bash

( time ( curl -kLs https://raw.githubusercontent.com/ryanwoodsmall/dockerfiles/master/crosware/Dockerfile \
         | sed s,busybox:musl,busybox:latest,g \
         | sed s,alpine:latest,amd64/alpine:latest,g \
         | sed s,debian:bullseye,riscv64/ubuntu:22.04,g \
         | docker build --tag ryanwoodsmall/crosware:riscv64 --no-cache --pull --rm --force-rm -
         echo $?
         sync
         sudo sync ) ) 2>&1 | tee /tmp/croswarebuild.out
