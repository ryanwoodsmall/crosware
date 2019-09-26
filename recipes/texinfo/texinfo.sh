rname="texinfo"
rver="6.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="988403c1542d15ad044600b909997ba3079b10e03224c61188117f3676b02caa"
rreqs="make sed perl ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  PATH=\"${cwsw}/perl/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --disable-nls
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
