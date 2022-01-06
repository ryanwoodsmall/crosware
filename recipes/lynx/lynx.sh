#
# XXX - gnutls variant
#

rname="lynx"
rver="2.8.9rel.1"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.bz2"
rurl="https://invisible-mirror.net/archives/${rname}/tarballs/${rfile}"
rsha256="387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
rreqs="ncurses openssl"

. "${cwrecipe}/lynx/lynx.sh.common"
