#
# XXX - alpine patches: https://git.alpinelinux.org/aports/tree/main/openssh
# XXX - move config to $cwtop/etc/openssh
#

rname="openssh"
rver="8.7p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="7ca34b8bb24ae9e50f33792b7091b3841d7e1b440ff57bc9fabddf01e2ed1e24"
rreqs="make zlib netbsdcurses groff"

sslprov="openssl"

. "${cwrecipe}/${rname%${sslprov}}/${rname%${sslprov}}.sh.common"
