#
# XXX - separate out static-only recipe?
#

rname="kuroko"
rver="1.3.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}-lang/${rname}/archive/refs/tags/${rfile}"
rsha256="7a41b0caa9b56c810ee3c5de3aefc6e71b95f4e6a667add92306f7b3e59515bc"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s,/usr/local,\$(cwidir_${rname}),g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS= CFLAGS=\"-Wl,-rpath,\$(cwidir_${rname})/current/lib -fPIC\" make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install-strip ${rlibtool}
  cwmakeinstall_${rname}_static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_static() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make clean
  cat Makefile.ORIG > Makefile
  sed -i.ORIG \"s,/usr/local,\$(cwidir_${rname})/static,g\" Makefile
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -static\" CC=\"\${CC} -DSTATIC_ONLY\" make
  make install-strip ${rlibtool}
  popd >/dev/null 2>&1
}
"
