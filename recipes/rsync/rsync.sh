#
# XXX - for rsync 3.2.x...
#     - openssl
# XXX - workaround ipv6 thing, via: https://git.alpinelinux.org/aports/tree/main/rsync/APKBUILD
#

rname="rsync"
rver="3.2.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="6f761838d08052b0b6579cf7f6737d93e47f01f4da04c5d24d3447b7f2a5fad1"
rreqs="make lz4 xxhash zstd attr acl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-included-popt \
    --with-included-zlib \
    --enable-acl-support \
    --enable-ipv6 \
    --enable-lz4 \
    --enable-xattr-support \
    --enable-xxhash \
    --enable-zstd \
    --disable-openssl \
    --disable-md5-asm \
    --disable-roll-asm \
    --disable-roll-simd \
      CFLAGS=\"\${CFLAGS} -DINET6\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
