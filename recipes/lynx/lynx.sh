#
# XXX - gnutls variant
# XXX - netbsdcurses (non-slang) HAVE_DELSCREEN/delete_screen/stop_curses breakage
#
rname="lynx"
rver="2.9.2"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.gz"
rurl="https://invisible-mirror.net/archives/${rname}/tarballs/${rfile}"
rsha256="99f8f28f860094c533100d1cedf058c27fb242ce25e991e2d5f30ece4457a3bf"
rreqs="ncurses openssl"

. "${cwrecipe}/lynx/lynx.sh.common"
