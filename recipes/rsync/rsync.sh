#
# XXX - for rsync 3.2.x...
#   - lz4
#   - openssl
#   - xxhash
#   - zstd
#

rname="rsync"
rver="3.2.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="644bd3841779507665211fd7db8359c8a10670c57e305b4aab61b4e40037afa8"
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
