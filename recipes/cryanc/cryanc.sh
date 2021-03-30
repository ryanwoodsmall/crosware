rname="cryanc"
rver="1.5"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/classilla/${rname}/archive/refs/tags/${rfile}"
rsha256="019c2a4df4ce5a332fc29b7903244d6a76bb0bd8bb3e406326b6239416a5b0f6"
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
