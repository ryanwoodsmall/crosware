rname="guile"
rver="3.0.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/guile/${rfile}"
rsha256="2dbdbc97598b2faf31013564efb48e4fed44131d28e996c26abe8a5b23b56c2a"
rreqs="make sed gawk gmp libtool slibtool pkgconfig libffi gc readline ncurses libunistring"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"
