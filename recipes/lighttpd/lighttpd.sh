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
# XXX - auth...
#  digest:
#    see: https://redmine.lighttpd.net/projects/lighttpd/wiki/Mod_auth#htdigest-mod_authn_file
#    user/realm/pass (apache2-utils/httpd-tools):
#      htdigest [-c] passwdfile realm username
#    or without any tools (md5):
#      echo -n 'user:realm:pass' | md5sum | sed 's/^/user:realm:/g' | tee -a .htpasswd
#    sha-256:
#      printf "%s:%s:%s:%s\n" "$user" "$realm" "$(printf "%s" "$user:$realm:$pass" | sha256sum | awk '{print $1}')" "$(printf "%s" "$user:$realm" | sha256sum | awk '{print $1}')"
#  basic:
#    minihttpd/thttpd have simple crypt `htpasswd`
#
#
rname="lighttpd"
rver="1.4.79"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://download.lighttpd.net/${rname}/releases-${rver%.*}.x/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="e08280166037e7607dfed2f73c938f6287672e2d8cefd3c2f7720688bb8fea03"
rreqs="make zlib bzip2 pcre2 mbedtls pkgconfig libbsd sqlite libxml2 attr brotli zstd xxhash lua netbsdcurses readlinenetbsdcurses xz"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  test -e src/compat || mkdir -p src/compat
  test -e src/compat/sys || ln -s ${cwsw}/libbsd/current/include/bsd/sys src/compat/
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/lua/current/bin:${cwsw}/pcre2/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --enable-ipv6 \
      --with-webdav-{locks,props} \
      --with-{pcre2,zlib,mbedtls,bzip2,attr,libxml,sqlite,brotli,zstd,xxhash,lua} \
        CC=\"\${CC} \$(pkg-config --cflags --libs libbsd-overlay zlib libpcre2-posix libxml-2.0)\" \
        CFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib\" \
        CXXFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
        LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -l{brotli,mbedx509,mbedtls,mbedcrypto})\" \
        BROTLI_CFLAGS=\"-I${cwsw}/brotli/current/include\" \
        BROTLI_LIBS=\"-L${cwsw}/brotli/current/lib -lbrotli\" \
        LUA_CFLAGS=\"-I${cwsw}/lua/current/include\" \
        LUA_LIBS=\"-L${cwsw}/lua/current/libs -llua\" \
        SQLITE_CFLAGS=\"-I${cwsw}/sqlite/current/include\" \
        SQLITE_LIBS=\"-L${cwsw}/sqlite/current/libs -lsqlite3\" \
        XML_CFLAGS=\"-I${cwsw}/libxml2/current/include\" \
        XML_LIBS=\"-L${cwsw}/libxml2/current/libs -lxml2\" \
        PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  rm -f \$(cwidir_${rname})/lib/*.la
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
