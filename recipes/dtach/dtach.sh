rname="dtach"
rver="0.9"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/crigler/${rname}/archive/${rfile}"
rsha256="5f7e8c835ee49a9e6dcf89f4e8ccbe724b061c0fc8565b504dd8b3e67ab79f82"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 0755 ${rname} \"${ridir}/bin/${rname}\"
  install -m 0644 ${rname}.1 \"${ridir}/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
