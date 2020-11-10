rname="grep"
rver="3.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="667e15e8afe189e93f9f21a7cd3a7b3f776202f417330b248c2ad4f997d9373e"
rreqs="make pcre sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --program-prefix=g --disable-nls
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
