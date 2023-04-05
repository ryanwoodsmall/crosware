rname="cryanc"
rver="2.2"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/classilla/${rname}/archive/refs/tags/${rfile}"
rsha256="2fa267ab96305d04b6144251f3a0fd7008aecae00aef43be0fb9bc2a75db0a7f"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \${CC} \${CFLAGS} carl.c -o carl -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/src\"
  install -m 0755 carl \"\$(cwidir_${rname})/bin/carl\"
  install -m 0644 carl.1 \"\$(cwidir_${rname})/share/man/man1/carl.1\"
  ln -sf carl \"\$(cwidir_${rname})/bin/${rname}\"
  cp *.{c,h,md} \"\$(cwidir_${rname})/src/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
