rname="tio"
rver="1.35"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="1309ecde7675f4e97cf363a8ab96ff668e14ab3f2176a15b6d626731251c9d09"
rreqs="meson"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \"${cwsw}/meson/current/bin/meson\" build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 755 \"build/src/${rname}\" \"${ridir}/bin/${rname}\"
  install -m 644 \"build/man/${rname}.1\" \"${ridir}/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
