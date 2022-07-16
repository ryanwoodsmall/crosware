rname="cryanc"
rver="2.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/classilla/${rname}/archive/refs/tags/${rfile}"
rsha256="3e5bdc08467b09d2e0b8899ae6feb9982b7a52b624c612be1f7b7d3399765bb0"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} \${CFLAGS} carl.c -o carl -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  cwmkdir \"${ridir}/src\"
  install -m 0755 carl \"${ridir}/bin/carl\"
  install -m 0644 carl.1 \"${ridir}/share/man/man1/carl.1\"
  ln -sf carl \"${ridir}/bin/${rname}\"
  cp *.{c,h,md} \"${ridir}/src/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
