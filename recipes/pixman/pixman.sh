rname="pixman"
rver="0.40.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.cairographics.org/releases/${rfile}"
rsha256="6d200dec3740d9ec4ec8d1180e25779c00bc749f94278c8b9021f5534db223fc"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-openmp \
    --disable-gtk \
    --disable-libpng \
    --disable-loongson-mmi \
    --disable-mmx \
    --disable-sse2 \
    --disable-ssse3 \
    --disable-vmx \
    --disable-arm-simd \
    --disable-arm-neon \
    --disable-arm-iwmmxt \
    --disable-arm-iwmmxt2 \
    --disable-mips-dspr2 \
    --disable-gcc-inline-asm \
    --enable-static-testprogs
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
