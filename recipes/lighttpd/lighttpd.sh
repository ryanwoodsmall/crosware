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
#  - lua
#  - zstd
#  - brotli
#  - gdbm
#  - memcached
# XXX - explicitly disable stuff?
#  - --without-{krb5,openssl,wolfssl,nettle,gnutls,nss,ldap,pam,fam,zstd,brotli,gdbm,xxhash,lua,sasl}
#

rname="lighttpd"
rver="1.4.59"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.lighttpd.net/${rname}/releases-${rver%.*}.x/${rfile}"
rsha256="fb953db273daef08edb6e202556cae8a3d07eed6081c96bd9903db957d1084d5"
rreqs="make zlib bzip2 pcre mbedtls pkgconfig libbsd sqlite libxml2 e2fsprogs attr libev"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-{ipv6,lfs} \
    --with-webdav-{locks,props} \
    --with-{pcre,zlib,mbedtls,bzip2,attr,libev,libxml,sqlite,uuid} \
      CC=\"\${CC} \$(pkg-config --cflags --libs libbsd)\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{bzip2,zlib,pcre,mbedtls,libxml2,sqlite,e2fsprogs,attr,libev}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{bzip2,zlib,pcre,mbedtls,libxml2,sqlite,e2fsprogs,attr,libev}/current/lib)\" \
      CFLAGS=-fPIC \
      CXXFLAGS=-fPIC
  grep -ril 'sys/queue\\.h' . \
  | xargs sed -i.ORIG 's,sys/queue,bsd/sys/queue,g'
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
