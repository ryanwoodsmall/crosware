#
# XXX - for rsync 3.2.x...
#   - lz4
#   - openssl
#   - xxhash
#   - zstd
#

rname="rsync"
rver="3.2.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="95f2dd62979b500a99b34c1a6453a0787ada0330e4bec7fcffad37b9062d58d3"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-included-popt \
    --with-included-zlib \
    --disable-asm \
    --disable-lz4 \
    --disable-openssl \
    --disable-simd \
    --disable-xxhash \
    --disable-zstd
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
