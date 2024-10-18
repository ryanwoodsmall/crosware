#
# XXX - pograms disabled, something pulls in generated files, which calls python, ad infinitum
# XXX - MBEDTLS_SSL_PROTO_TLS1_3
# XXX - MBEDTLS_SSL_SRV_C
# XXX - WHOLE bunch more: include/mbedtls/check_config.h
#
sname="mbedtls"
rname="${sname}36"
rver="3.6.2"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${rver}/${rfile}"
rsha256="8b54fb9bcf4d5a7078028e0520acddefb7900b3e66fec7f7175bb5b7d85ccdca"

. "${cwrecipe}/${sname}/${sname}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"s#^DESTDIR=.*#DESTDIR=\$(cwidir_${rname})#g\" Makefile
  sed -i '/^all:/s,tests,,g' Makefile
  sed -i '/^programs:/s,mbedtls_test,,g' Makefile
  sed -i '/^install:/s,no_test,lib,g' Makefile
  sed -i '/MAKE.*test/s,\$(MAKE),: \$(MAKE),g' Makefile
  sed -i '/DESTDIR.*bin/s,\\(mkdir\\|cp\\|rm\\),: \\1,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local gd=''
  gd+=' -DMBEDTLS_THREADING_C '
  gd+=' -DMBEDTLS_THREADING_PTHREAD '
  local r=''
  local p=\"\$(for r in ccache4 ccache statictoolchain bashtiny bootstrapmake busybox ; do echo ${cwsw}/\${r}/current/bin ; done | paste -s -d: -)\"
  env PATH=\"\${p}\" make -j${cwmakejobs} lib CC=\"\${CC} -Os \${gd}\" C{,XX}FLAGS=\"-Os -Wl,-s \${CFLAGS} \${gd}\" LDFLAGS=\"-static -s\" CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= GEN_FILES= PATH=\"\${p}\" PERL=true PYTHON=true
  popd &>/dev/null
}
"

unset sname
