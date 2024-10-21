#
# XXX - virtualize; openssl, libressl, mbedtls, minimal variants
#
rname="civetweb"
rver="1.16"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/civetweb/civetweb/archive/refs/tags/${rfile}"
rsha256="f0e471c1bf4e7804a6cfb41ea9d13e7d623b2bcc7bc1e2a4dd54951a24d60285"
rreqs="bootstrapmake mbedtls zlib"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's,-lmbedcrypto -lmbedtls -lmbedx509,-lmbedx509 -lmbedtls -lmbedcrypto,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export margs=\"PREFIX=\$(cwidir_${rname}) WITH_X_DOM_SOCKET=1 WITH_SERVER_STATS=1 WITH_LUA=1 WITH_DUKTAPE=1 WITH_IPV6=1 WITH_WEBSOCKET=1 WITH_ZLIB=1 WITH_MBEDTLS=1\"
    export CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{mbedtls,zlib}/current/include) \$(echo -L${cwsw}/{mbedtls,zlib}/current/lib)\"
    export CXX=\"\${CXX} \${CXXFLAGS} \$(echo -I${cwsw}/{mbedtls,zlib}/current/include) \$(echo -L${cwsw}/{mbedtls,zlib}/current/lib)\"
    unset {C{PP,XX,},LD}FLAGS PKG_CONFIG_{LIBDIR,PATH}
    make \${margs} \
    && make \${margs} install
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
