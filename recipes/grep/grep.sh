rname="grep"
rver="3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="8e6e1f05bf76c30f52605278d0ab06c322e7bfa69e3c193499a8fd2c2c31599c"
rreqs="make pcre sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --program-prefix=g
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install
  ln -sf g${rname} ${ridir}/bin/${rname}
  ln -sf ge${rname} ${ridir}/bin/e${rname}
  ln -sf gf${rname} ${ridir}/bin/f${rname}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
