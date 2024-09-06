#
# XXX - pograms disabled, something pulls in generated files, which calls python, ad infinitum
# XXX - MBEDTLS_SSL_PROTO_TLS1_3
# XXX - MBEDTLS_SSL_SRV_C
# XXX - WHOLE bunch more: include/mbedtls/check_config.h
#
sname="mbedtls"
rname="${sname}36"
rver="3.6.1"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${rver}/${rfile}"
rsha256="fc8bef0991b43629b7e5319de6f34f13359011105e08e3e16eed3a9fe6ffd3a3"

. "${cwrecipe}/${sname}/${sname}.sh.common"


eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i \"s#^DESTDIR=.*#DESTDIR=\$(cwidir_${rname})#g\" Makefile
  sed -i '/^all:/s,tests,,g' Makefile
  sed -i '/^programs:/s,mbedtls_test,,g' Makefile
  sed -i '/^install:/s,no_test,lib,g' Makefile
  sed -i '/MAKE.*test/s,\$(MAKE),: \$(MAKE),g' Makefile
  sed -i '/DESTDIR.*bin/s,\\(mkdir\\|cp\\|rm\\),: \\1,g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmyfuncname
  local gd=''
  gd+=' -DMBEDTLS_THREADING_C '
  gd+=' -DMBEDTLS_THREADING_PTHREAD '
  local r=''
  local p=\"\$(for r in ccache4 ccache statictoolchain bashtiny bootstrapmake busybox ; do echo ${cwsw}/\${r}/current/bin ; done | paste -s -d: -)\"
  env PATH=\"\${p}\" make -j${cwmakejobs} lib CC=\"\${CC} -Os \${gd}\" C{,XX}FLAGS=\"-Os -Wl,-s \${CFLAGS} \${gd}\" LDFLAGS=\"-static -s\" CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= GEN_FILES= PATH=\"\${p}\"
  popd >/dev/null 2>&1
}
"

unset sname
