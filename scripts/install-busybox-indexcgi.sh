#!/usr/bin/env bash

#
# fetch and download busybox's index.cgi into a local cgi-bin for easy 'busybox httpd' indexes
#

set -eu

mkdir -p cgi-bin
curl -kLs 'https://git.busybox.net/busybox/plain/networking/httpd_indexcgi.c?h=1_31_stable' \
| gcc -o cgi-bin/index.cgi -static -xc -
