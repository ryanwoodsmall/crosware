rname="neatvi"
rver="07"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/aligrudi/${rname}/archive/${rfile}"
rsha256="f35939b5095152af9e8e76dd03ef4f52d14453a70a92430dd3e92964dcca53a1"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC}\" LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  rm -f \"${ridir}/bin/${rname}\"
  install -m 0755 vi \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
