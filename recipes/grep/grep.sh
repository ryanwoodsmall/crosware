rname="grep"
rver="3.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="b82ac77707c2ab945520c8404c9fa9f890f7791a62cf2103cf6238acad87a44a"
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
