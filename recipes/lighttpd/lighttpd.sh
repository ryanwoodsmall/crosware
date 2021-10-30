#
# XXX - should default be openssl instead of mbedtls?
#  - idea is for "smallest viable secure/featured web server"
#  - so maybe not
# XXX - variants...
#  - openssl
#  - libressl
#  - wolfssl
#  - gnutls
#  - nettle
# XXX - features...
#  - libev "no longer recommended" - https://redmine.lighttpd.net/projects/lighttpd/wiki/Server_event-handlerDetails
#  - gdbm
#  - memcached
# XXX - explicitly disable stuff?
#  - --without-{krb5,openssl,wolfssl,nettle,gnutls,nss,ldap,pam,fam,gdbm,sasl,libev}
#

rname="lighttpd"
rver="1.4.61"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.lighttpd.net/${rname}/releases-${rver%.*}.x/${rfile}"
rsha256="43f0d63d04a1b7c5b8aab07e0612e44ccad0afc0614bab784c5b019872363432"
rreqs="make zlib bzip2 pcre mbedtls pkgconfig libbsd sqlite libxml2 e2fsprogs attr brotli zstd xxhash lua54"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/lua54/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --enable-{ipv6,lfs} \
      --with-webdav-{locks,props} \
      --with-{pcre,zlib,mbedtls,bzip2,attr,libxml,sqlite,uuid,brotli,zstd,xxhash,lua} \
        CC=\"\${CC} \$(pkg-config --cflags --libs libbsd)\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{bzip2,zlib,pcre,mbedtls,libxml2,sqlite,e2fsprogs,attr,brotli,zstd,xxhash,lua54}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{bzip2,zlib,pcre,mbedtls,libxml2,sqlite,e2fsprogs,attr,brotli,zstd,xxhash,lua54}/current/lib)\" \
        CFLAGS=-fPIC \
        CXXFLAGS=-fPIC \
        LUA_CFLAGS=\"-I${cwsw}/lua54/current/include\" \
        LUA_LIBS=\"-L${cwsw}/lua54/current/libs -llua\"
  grep -ril 'sys/queue\\.h' . \
  | xargs sed -i.ORIG 's,sys/queue,bsd/sys/queue,g'
  cat >>config.h<<EOF
#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern \"C\" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS
# define __END_DECLS
#endif
EOF
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -f ${ridir}/lib/*.la
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
