#
# XXX - for rsync 3.2.x...
#     - openssl
# XXX - workaround ipv6 thing, via: https://git.alpinelinux.org/aports/tree/main/rsync/APKBUILD
#
rname="rsync"
rver="3.5.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/rsync/src/${rfile}"
rsha256="c7ffd1ef653e99540f661e47cb00b7f9cad1ee6b972399b16f93d672656e0d33"
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
