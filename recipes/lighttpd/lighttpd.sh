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
#  - gdbm
#  - memcached
# XXX - explicitly disable stuff?
#  - --without-{krb5,openssl,wolfssl,nettle,gnutls,nss,ldap,pam,fam,gdbm,sasl}
# XXX - quick/dirty md5 htdigest passwords without htdigest from apache httpd:
#  - echo "user:realm:$(echo -n user:realm:password | md5sum | awk '{print $1}')"
#  - need to cut the first 32 chars for the digest?
#  - keep user+realm short!
#  - https://github.com/apache/httpd/blob/trunk/support/htdigest.c
#

rname="lighttpd"
rver="1.4.69"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="https://download.lighttpd.net/${rname}/releases-${rver%.*}.x/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="16ac8db95e719629ba61949b99f8a26feba946a81d185215b28379bb4116b0b4"
rreqs="make zlib bzip2 pcre2 mbedtls pkgconfig libbsd sqlite libxml2 e2fsprogs attr brotli zstd xxhash lua54 netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/lua54/current/bin:${cwsw}/pcre2/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --enable-{ipv6,lfs} \
      --with-webdav-{locks,props} \
      --with-{pcre2,zlib,mbedtls,bzip2,attr,libxml,sqlite,uuid,brotli,zstd,xxhash,lua} \
        CC=\"\${CC} \$(pkg-config --cflags --libs libbsd-overlay zlib libpcre2-posix libxml-2.0)\" \
        CFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib\" \
        CXXFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
        LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -l{brotli,mbedx509,mbedtls,mbedcrypto})\" \
        BROTLI_CFLAGS=\"-I${cwsw}/brotli/current/include\" \
        BROTLI_LIBS=\"-L${cwsw}/brotli/current/lib -lbrotli\" \
        LUA_CFLAGS=\"-I${cwsw}/lua54/current/include\" \
        LUA_LIBS=\"-L${cwsw}/lua54/current/libs -llua\" \
        SQLITE_CFLAGS=\"-I${cwsw}/sqlite/current/include\" \
        SQLITE_LIBS=\"-L${cwsw}/sqlite/current/libs -lsqlite3\" \
        XML_CFLAGS=\"-I${cwsw}/libxml2/current/include\" \
        XML_LIBS=\"-L${cwsw}/libxml2/current/libs -lxml2\" \
        PKG_CONFIG_{LIBDIR,PATH}=
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
