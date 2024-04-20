#
# XXX - gnutls variant
# XXX - netbsdcurses (non-slang) HAVE_DELSCREEN/delete_screen/stop_curses breakage
#
rname="lynx"
rver="2.9.1"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.gz"
rurl="https://invisible-mirror.net/archives/${rname}/tarballs/${rfile}"
rsha256="085fb3924b8684485c6be1b1ca745417da6ace768f94428ead95caf9dd8b56b7"
rreqs="ncurses openssl"

. "${cwrecipe}/lynx/lynx.sh.common"
