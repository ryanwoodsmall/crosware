rname="libproxyprotocol"
rver="1.2.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kosmas-valianos/libproxyprotocol/archive/refs/tags/${rfile}"
rsha256="21228646c8d468f7950cff08dae79eda769691d82108c19dd76085b0cdbb5cee"
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
