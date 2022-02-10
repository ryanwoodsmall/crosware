#
# XXX - untar:
#   https://github.com/libarchive/libarchive/blob/master/contrib/untar.c
#   https://github.com/libarchive/libarchive/blob/master/examples/untar.c
# XXX - minitar:
#   https://github.com/libarchive/libarchive/tree/master/examples/minitar
# XXX - shar:
#   https://github.com/libarchive/libarchive/tree/master/contrib/shar
#

rname="libarchive"
rver="3.6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="df283917799cb88659a5b33c0a598f04352d61936abcd8a48fe7b64e74950de7"
rreqs="make expat zlib bzip2 lz4 lzo zstd mbedtls xz libmd attr acl e2fsprogs libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-acl \
    --enable-bsd{cat,cpio,tar}=static \
    --enable-posix-regex-lib \
    --enable-xattr \
    --with-bz2lib \
    --with-expat \
    --with-lz4 \
    --with-lzma \
    --with-lzo2 \
    --with-mbedtls \
    --with-zlib \
    --with-zstd \
    --without-openssl \
    --without-nettle \
    --without-xml2 \
      CC=\"\${CC} \$(pkg-config --{cflags,libs} libbsd-overlay)\" \
      CPP=\"\${CPP} \$(pkg-config --cflags libbsd-overlay)\" \
      CFLAGS=\"\${CFLAGS} -Wl,-s\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lbsd -lmd -lmbedtls -lmbedcrypto -lmbedx509'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
