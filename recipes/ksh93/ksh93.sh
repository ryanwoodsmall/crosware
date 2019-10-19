#
# XXX - rename to bare ksh w/o 93? probably not...
#

rname="ksh93"
rver="2020.0.0"
rdir="${rname%%93}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/att/ast/releases/download/${rver}/${rfile}"
rsha256="3d6287f9ad13132bf8e57a8eac512b36a63ccce2b1e4531d7a946c5bf2375c63"
rreqs="meson ninja muslfts"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  meson build --prefix=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ninja -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/ksh*\"
  ninja -C build install
  mv \"${ridir}/bin/ksh\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/ksh\"
  strip --strip-all \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
