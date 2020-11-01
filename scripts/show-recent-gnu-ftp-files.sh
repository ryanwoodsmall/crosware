#!/bin/bash

#
# shows a list of recently updated (this month) files on ftp.gnu.org
#
# awk would be better here but who has the time?
#

set -eu

ftpgnuls="https://ftp.gnu.org/ls-lrRt.txt.gz"
: ${month:="$(date '+%b')"}

curl -kLs "${ftpgnuls}" \
| gzip -dc \
| egrep -- '(^-|:$)' \
| tr '\t' ' ' \
| tr -s ' ' \
| cut -f6- -d' ' \
| egrep "(^${month} .*:|^/.*:$)" \
| grep -B1 "${month} " \
| grep -v -- '^--$'
