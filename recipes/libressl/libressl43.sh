rver="4.3.5"
rname="libressl${rver%.*}"
rname="${rname//./}"
rsha256="62d34978f5f78dbc639e3a8ebd9c9caac45f0965e03c6fb32896845c5e67dfb7"

. "${cwrecipe}/libressl/libressl.sh.common"

# XXX - remove or move to this/next version when bare "libressl" default changes!
# XXX - this may (will) be overwritten by cacertificates
cwprependfunc "cwmakeinstall_${rname}" 'cwscriptecho "fixing ${cwetc}/libressl/cert.pem"'
cwprependfunc "cwmakeinstall_${rname}" 'test -e ${cwetc}/libressl/cert.pem && mv ${cwetc}/libressl/cert.pem{,.PRE-${TS}} || true'

# vim: set ft=bash:
