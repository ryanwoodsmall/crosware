rname="vile"
rver="9.8z"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/current/${rfile}"
rsha256="0b3286c327b70a939f21992d22e42b5c1f8a6e953bd9ab9afa624ea2719272f7"
rreqs="make flex ncurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-screen=ncurses \
    --with-builtin-filters=all \
    --with-loadable-filters=none \
      LEX=\"${cwsw}/flex/current/bin/flex\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/flex/current/include -I${cwsw}/ncurses/current/include{,/ncurses{,w}})\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{flex,ncurses}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/ncurses/current/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make LEX=\"${cwsw}/flex/current/bin/flex\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
