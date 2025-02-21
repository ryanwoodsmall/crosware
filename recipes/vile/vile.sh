rname="vile"
rver="9.8za"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/current/${rfile}"
rsha256="65ba15ec145dfc5506217162228c7d88f01c0490a0dccde7a8a19f1c7c1b93b2"
rreqs="make flex ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --with-screen=ncurses \
    --with-builtin-filters=all \
    --with-loadable-filters=none \
      LEX=\"${cwsw}/flex/current/bin/flex\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/flex/current/include -I${cwsw}/ncurses/current/include{,/ncurses{,w}})\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{flex,ncurses}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/ncurses/current/lib/pkgconfig\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make LEX=\"${cwsw}/flex/current/bin/flex\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
