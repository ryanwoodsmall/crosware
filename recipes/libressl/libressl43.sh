rver="4.3.4"
rname="libressl${rver%.*}"
rname="${rname//./}"
rsha256="57c8b2f8c6f9505587abaeddab003ea243d615edb7ed71957968121fc6316bd6"

. "${cwrecipe}/libressl/libressl.sh.common"

# XXX - remove or move to this/next version when bare "libressl" default changes!
# XXX - this may (will) be overwritten by cacertificates
cwprependfunc "cwmakeinstall_${rname}" 'cwscriptecho "fixing ${cwetc}/libressl/cert.pem"'
cwprependfunc "cwmakeinstall_${rname}" 'test -e ${cwetc}/libressl/cert.pem && mv ${cwetc}/libressl/cert.pem{,.PRE-${TS}} || true'

# vim: set ft=bash:
