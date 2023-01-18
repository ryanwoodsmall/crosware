rname="vile"
rver="9.8y"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/current/${rfile}"
rsha256="1b67f1ef34f5f2075722ab46184bb149735e8538fa912fc07c985c92f78fe381"
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
