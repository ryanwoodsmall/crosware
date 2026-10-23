rver="4.4.0"
rname="libressl${rver%.*}"
rname="${rname//./}"
rsha256="7d02522ad5070b9adb32eb253ecabce181184a3750cf65abac0675ee908687c1"

. "${cwrecipe}/libressl/libressl.sh.common"

# XXX - remove or move to this/next version when bare "libressl" default changes!
# XXX - this may (will) be overwritten by cacertificates
cwprependfunc "cwmakeinstall_${rname}" 'cwscriptecho "fixing ${cwetc}/libressl/cert.pem"'
cwprependfunc "cwmakeinstall_${rname}" 'mv ${cwetc}/libressl/cert.pem{,.PRE-${TS}}'

# vim: set ft=bash:
