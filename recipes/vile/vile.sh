rname="vile"
rver="9.8t"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/current/${rfile}"
rsha256="60b288432cfd32b7149c4cd662844e2694c5ab92bc469b282f33ded5110f6ded"
rreqs="make flex ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  make LEX=\"${cwsw}/flex/current/bin/flex\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
