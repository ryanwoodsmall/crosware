rname="guile"
rver="3.0.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="daa7060a56f2804e9b74c8d7e7fe8beed12b43aab2789a38585183fcc17b8a13"
rreqs="make sed gawk gmp libtool slibtool pkgconfig libffi gc readline ncurses libunistring"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"
