#
# XXX - pograms disabled, something pulls in generated files, which calls python, ad infinitum
# XXX - MBEDTLS_SSL_PROTO_TLS1_3
# XXX - MBEDTLS_SSL_SRV_C
# XXX - WHOLE bunch more: include/mbedtls/check_config.h
#
sname="mbedtls"
rname="${sname}36"
rver="3.6.3.1"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
#rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${rver}/${rfile}"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/v${rver}/${rfile}"
rsha256="243ed496d5f88a5b3791021be2800aac821b9a4cc16e7134aa413c58b4c20e0c"

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
