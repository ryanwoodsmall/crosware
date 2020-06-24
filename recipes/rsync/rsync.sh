#
# XXX - for rsync 3.2.x...
#   - lz4
#   - openssl
#   - xxhash
#   - zstd
#

rname="rsync"
rver="3.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="90127fdfb1a0c5fa655f2577e5495a40907903ac98f346f225f867141424fa25"
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
