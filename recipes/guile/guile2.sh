rname="guile2"
rver="2.2.7"
rdir="${rname%2}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
rsha256="cdf776ea5f29430b1258209630555beea6d2be5481f9da4d64986b077ff37504"
rreqs="make sed gawk gmp libtool slibtool pkgconfig libffi gc readline ncurses libunistring"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%2}/${rname%2}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --program-suffix=${rver%%.*}
  popd >/dev/null 2>&1
}
"
