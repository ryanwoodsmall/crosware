#
# XXX - for rsync 3.2.x...
#     - openssl
# XXX - workaround ipv6 thing, via: https://git.alpinelinux.org/aports/tree/main/rsync/APKBUILD
# XXX - 3.4.3 introduced a reliance on linux/openat2.h, needs linux 5.6+
#
rname="rsync"
rver="3.4.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/rsync/src/${rfile}"
rsha256="bd88cf82fa653da32314fb229136407c5c90f80d1758d8f4b091767877d8fa96"
rreqs="make lz4 xxhash zstd attr acl"

. "${cwrecipe}/common.sh"

## XXX - UGH
#eval "
#function cwpatch_${rname}() {
#  pushd \"\$(cwbdir_${rname})\" &>/dev/null
#  cat rsync.h > rsync.h.ORIG
#  echo '#include <sys/syscall.h>' > rsync.h
#  cat rsync.h.ORIG >> rsync.h
#  cat syscall.c > syscall.c.ORIG
#  echo '#undef __linux__' > syscall.c
#  cat syscall.c.ORIG >> syscall.c
#  popd &>/dev/null
#}
#"

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
