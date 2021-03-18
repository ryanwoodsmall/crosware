rname="dvtm"
rver="0.15"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/martanne/dvtm/releases/download/v${rver}/${rfile}"
rsha256="8f2015c05e2ad82f12ae4cf12b363d34f527a4bbc8c369667f239e4542e1e510"
rreqs="make abduco netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/^PREFIX/s,^PREFIX.*,PREFIX=${ridir},g' config.mk
  sed -i 's/-lncursesw/-lcurses -lterminfo/g' config.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC} -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install CC=\"\${CC} -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
