rname="vile"
rver="9.8zb"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/current/${rfile}"
rsha256="d6239e6b728fa9d0b49f526d8f0998d2db4b7a7dfc317273dbff7aea2a09ea31"
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
