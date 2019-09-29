rname="ksh93"
rver="2020.0.0"
rdir="ast-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/att/ast/archive/${rfile}"
rsha256="b10527459a7d0acd96ff730ad6f4e09e0d2c2b7df2925c0cd533a738fea3a8dc"
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
