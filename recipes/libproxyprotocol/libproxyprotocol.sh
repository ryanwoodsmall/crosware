rname="libproxyprotocol"
rver="1.3.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kosmas-valianos/libproxyprotocol/archive/refs/tags/${rfile}"
rsha256="c7a12aaca7bee89e155d9c3fae781615989beefa8529058515b8dbd0e66a0597"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/{include,lib}
  \${CC} \${CFLAGS} -Wall -Wextra -Wshadow -Wimplicit-fallthrough=0 -ansi -fshort-enums -c src/proxy_protocol.c -o src/proxy_protocol.o
  \${AR} -v -r src/libproxyprotocol.a src/proxy_protocol.o
  ranlib src/libproxyprotocol.a
  install -m 0644 src/proxy_protocol.h \$(cwidir_${rname})/include/proxy_protocol.h
  install -m 0644 src/libproxyprotocol.a \$(cwidir_${rname})/lib/libproxyprotocol.a
  popd &>/dev/null
}
"

# -Wall -Wextra -Wshadow -Wimplicit-fallthrough=0 -ansi -fshort-enums -fpic
