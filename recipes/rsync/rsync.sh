#
# XXX - for rsync 3.2.x...
#   - lz4
#   - openssl
#   - xxhash
#   - zstd
#

rname="rsync"
rver="3.2.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="becc3c504ceea499f4167a260040ccf4d9f2ef9499ad5683c179a697146ce50e"
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
