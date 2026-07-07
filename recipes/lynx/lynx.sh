#
# XXX - gnutls variant
# XXX - netbsdcurses (non-slang) HAVE_DELSCREEN/delete_screen/stop_curses breakage
#
rname="lynx"
rver="2.9.3"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.gz"
rurl="https://invisible-mirror.net/archives/${rname}/tarballs/${rfile}"
rsha256="6e99e46980974a6d89eceefbb26ca8c7aa7702b78ecb5bad383b859af225d052"
rreqs="ncurses openssl"

. "${cwrecipe}/lynx/lynx.sh.common"
