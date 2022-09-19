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
# XXX - quick/dirty md5 htdigest passwords without htdigest from apache httpd:
#  - echo "user:realm:$(echo -n user:realm:password | md5sum | awk '{print $1}')"
#  - need to cut the first 32 chars for the digest?
#  - keep user+realm short!
#  - https://github.com/apache/httpd/blob/trunk/support/htdigest.c
#

rname="lighttpd"
rver="1.4.67"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.lighttpd.net/${rname}/releases-${rver%.*}.x/${rfile}"
rsha256="7e04d767f51a8d824b32e2483ef2950982920d427d1272ef4667f49d6f89f358"
rreqs="make zlib bzip2 pcre2 mbedtls pkgconfig libbsd sqlite libxml2 e2fsprogs attr brotli zstd xxhash lua54"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/lua54/current/bin:${cwsw}/pcre2/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --enable-{ipv6,lfs} \
      --with-webdav-{locks,props} \
      --with-{pcre2,zlib,mbedtls,bzip2,attr,libxml,sqlite,uuid,brotli,zstd,xxhash,lua} \
        CC=\"\${CC} \$(pkg-config --cflags --libs libbsd)\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{bzip2,zlib,pcre2,mbedtls,libxml2,sqlite,e2fsprogs,attr,brotli,zstd,xxhash,lua54}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{bzip2,zlib,pcre2,mbedtls,libxml2,sqlite,e2fsprogs,attr,brotli,zstd,xxhash,lua54}/current/lib)\" \
        LIBS=\"\$(echo -L${cwsw}/{brotli,mbedtls}/current/lib -l{brotli,mbedx509,mbedtls,mbedcrypto})\" \
        CFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib\" \
        CXXFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib\" \
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -f \$(cwidir_${rname})/lib/*.la
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
