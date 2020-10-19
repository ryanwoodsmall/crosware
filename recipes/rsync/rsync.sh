#
# XXX - for rsync 3.2.x...
#   - openssl
#

rname="rsync"
rver="3.2.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="becc3c504ceea499f4167a260040ccf4d9f2ef9499ad5683c179a697146ce50e"
rreqs="make lz4 xxhash zstd"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-included-popt \
    --with-included-zlib \
    --enable-lz4 \
    --enable-xxhash \
    --enable-zstd \
    --disable-openssl \
    --disable-asm \
    --disable-simd
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
