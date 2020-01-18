rname="guile2"
rver="2.2.6"
rdir="${rname%2}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
rsha256="b33576331465a60b003573541bf3b1c205936a16c407bc69f8419a527bf5c988"
rreqs="make sed gawk gmp libtool slibtool pkgconfig libffi gc readline ncurses libunistring"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%2}/${rname%2}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --program-suffix=${rver%%.*}
  popd >/dev/null 2>&1
}
"
