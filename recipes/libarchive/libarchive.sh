#
# XXX - untar:
#   https://github.com/libarchive/libarchive/blob/master/contrib/untar.c
#   https://github.com/libarchive/libarchive/blob/master/examples/untar.c
# XXX - minitar:
#   https://github.com/libarchive/libarchive/tree/master/examples/minitar
# XXX - shar:
#   https://github.com/libarchive/libarchive/tree/master/contrib/shar
# XXX - ugh...
#   libtool: compile:  x86_64-linux-musl-gcc -DLIBBSD_OVERLAY -isystem /usr/local/crosware/software/libbsd/libbsd-0.11.7/include/bsd -lbsd -DHAVE_CONFIG_H -I.  -Wl,-static -fPIC -Wl,-s -Wall -Wformat -Wformat-security -ffunction-sections -fdata-sections -fvisibility=hidden -D__LIBARCHIVE_ENABLE_VISIBILITY -MT libarchive/archive_read_disk_posix.lo -MD -MP -MF libarchive/.deps/archive_read_disk_posix.Tpo -c libarchive/archive_read_disk_posix.c -o libarchive/archive_read_disk_posix.o
#   libarchive/archive_read_disk_posix.c: In function 'setup_current_filesystem':
#   libarchive/archive_read_disk_posix.c:1869:41: error: 'struct statvfs' has no member named 'f_namelen'; did you mean 'f_namemax'?
#    1869 |  t->current_filesystem->name_max = svfs.f_namelen;
#         |                                         ^~~~~~~~~
#         |                                         f_namemax
#

rname="libarchive"
rver="3.7.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="44729a0cc3b0b0be6742a9873d25e85e240c9318f5f5ebf2cca6bc84d7b91b07"
rreqs="make expat zlib bzip2 lz4 lzo zstd mbedtls xz libmd attr acl e2fsprogs libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/svfs.*f_namelen/s,svfs,sfs,g' libarchive/archive_read_disk_posix.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lbsd -lmd -lmbedtls -lmbedcrypto -lmbedx509'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  sed -i '/iconv/d' \"\$(cwidir_${rname})/lib/pkgconfig/libarchive.pc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
