#
# XXX - for rsync 3.2.x...
#     - openssl
# XXX - workaround ipv6 thing, via: https://git.alpinelinux.org/aports/tree/main/rsync/APKBUILD
#
rname="rsync"
rver="3.4.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/rsync/src/${rfile}"
rsha256="2924bcb3a1ed8b551fc101f740b9f0fe0a202b115027647cf69850d65fd88c52"
rreqs="make lz4 xxhash zstd attr acl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
