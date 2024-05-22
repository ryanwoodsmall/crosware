sname="mbedtls"
rname="${sname}36"
rver="3.6.0"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/v${rver}/${rfile}"
rsha256="3ecf94fcfdaacafb757786a01b7538a61750ebd85c4b024f56ff8ba1490fcd38"

. "${cwrecipe}/${sname}/${sname}.sh.common"


eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s#^DESTDIR=.*#DESTDIR=\$(cwidir_${rname})#g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local gd=''
  gd+=' -DMBEDTLS_THREADING_C '
  gd+=' -DMBEDTLS_THREADING_PTHREAD '
  make -j${cwmakejobs} no_test CC=\"\${CC} -Os \${gd}\" C{,XX}FLAGS=\"-Os -Wl,-s \${CFLAGS} \${gd}\" LDFLAGS=\"-static -s\" CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

unset sname
