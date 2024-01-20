#
# XXX - gnutls variant
# XXX - netbsdcurses (non-slang) HAVE_DELSCREEN/delete_screen/stop_curses breakage
#
rname="lynx"
rver="2.9.0"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.gz"
rurl="https://invisible-mirror.net/archives/${rname}/tarballs/${rfile}"
rsha256="746c926e28d50571a42d2477f9c50784b27fc8cba4c7db7f3e6c9e00dde89070"
rreqs="ncurses openssl"

. "${cwrecipe}/lynx/lynx.sh.common"
