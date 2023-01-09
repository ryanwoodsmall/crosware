rname="vile"
rver="9.8x"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/current/${rfile}"
rsha256="8fe0dfa60179d4b7dd2750f116cd4396d4cd3e07d8a54d142a36c84f4a82feef"
rreqs="make flex ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-screen=ncurses \
    --with-builtin-filters=all \
    --with-loadable-filters=none \
      LEX=\"${cwsw}/flex/current/bin/flex\"
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
