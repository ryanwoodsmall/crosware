#
# XXX - openssl?
# XXX - workaround ipv6 thing, via: https://git.alpinelinux.org/aports/tree/main/rsync/APKBUILD
#
rname="rsync"
rver="3.5.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/rsync/src/${rfile}"
rsha256="c55f9c9dc10fb8bec397b399a0fdded53cc9a2d8e30891bb0d63724d25c37bef"
rreqs="make lz4 xxhash zstd attr acl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --disable-idn \
    --disable-md5-asm \
    --disable-openssl \
    --disable-roll-asm \
    --disable-roll-simd \
    --enable-acl-support \
    --enable-ipv6 \
    --enable-lz4 \
    --enable-xattr-support \
    --enable-xxhash \
    --enable-zstd \
    --with-included-popt \
    --with-included-zlib \
      CFLAGS=\"\${CFLAGS} -DINET6\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
