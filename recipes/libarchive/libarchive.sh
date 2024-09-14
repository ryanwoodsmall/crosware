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
rver="3.7.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/libarchive/${rname}/releases/download/v${rver}/${rfile}"
rsha256="37556113fe44d77a7988f1ef88bf86ab68f53d11e85066ffd3c70157cc5110f1"
rreqs="make expat zlib bzip2 lz4 lzo zstd mbedtls xz libmd attr acl e2fsprogs libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-acl \
    --enable-bsd{cat,cpio,tar,unzip}=static \
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
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lbsd -lmd -lmbedtls -lmbedcrypto -lmbedx509'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  sed -i '/iconv/d' \"\$(cwidir_${rname})/lib/pkgconfig/libarchive.pc\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
