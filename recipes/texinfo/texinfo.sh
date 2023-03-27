rname="texinfo"
rver="7.0.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="74b420d09d7f528e84f97aa330f0dd69a98a6053e7a4e01767eed115038807bf"
rreqs="make sed perl ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  PATH=\"${cwsw}/perl/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --disable-nls
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
