rver="4.4.1"
rname="libressl${rver%.*}"
rname="${rname//./}"
rsha256="290cdf1b53c086255dc302f118b98602a444e9ae6d11e9bfdd8c9b1b60aa3a22"

. "${cwrecipe}/libressl/libressl.sh.common"

# XXX - remove or move to this/next version when bare "libressl" default changes!
# XXX - this may (will) be overwritten by cacertificates
cwprependfunc "cwmakeinstall_${rname}" 'cwscriptecho "fixing ${cwetc}/libressl/cert.pem"'
cwprependfunc "cwmakeinstall_${rname}" 'test -e ${cwetc}/libressl/cert.pem && mv ${cwetc}/libressl/cert.pem{,.PRE-${TS}} || true'

# vim: set ft=bash:
