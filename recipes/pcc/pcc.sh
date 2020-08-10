#
# XXX - very ugly
# XXX - x86_64 only for now, weird errors on 32-bit arches, aarch64 not supported
# XXX - pcc-libs patch: https://git.alpinelinux.org/aports/tree/community/pcc-libs/musl-fixes.patch
# XXX - need to replace .o startup files (crt1.o, crti.o, crtn.o) with the ones from muslstandalone
# XXX - symlink here, cp may be better?
# XXX - use of musl-gcc path precludes ccache
#

rname="pcc"
rver="20191221"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
#rurl="ftp://pcc.ludd.ltu.se/pub/${rname}/${rfile}"
rurl="http://pcc.ludd.ltu.se/ftp/pub/${rname}/${rfile}"
rsha256="7e31c898a79450badc9be30fb2495e222ca819d3d5d8bd3e441016270953898d"
rreqs="make byacc flex configgit muslstandalone"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  local f u d s
  f=\"${rfile//pcc/pcc-libs}\"
  u=\"${rurl%/*}-libs/\${f}\"
  d=\"${rdlfile%/*}/\${f}\"
  s=\"b374ef192ac204f5356038a744cac9436405a9d5cf015288f654b3b9b0badc19\"
  cwfetchcheck \"\${u}\" \"\${d}\" \"\${s}\"
  unset f u d s
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"${rdlfile//pcc-/pcc-libs-}\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local s=\"${cwsw}/statictoolchain/current\"
  local t=\"${cwsw}/muslstandalone/current\"
  local m=\"\$(\${t}/bin/musl-gcc -dumpmachine)\"
  local c d
  for c in config.{guess,sub} ; do
    for d in . ${rname}-libs-${rver} ; do
      rm -f \${d}/\${c}
      install -m 0755 ${cwsw}/configgit/current/\${c} \${d}/\${c}
    done
  done
  env CPPFLAGS= LDFLAGS=-static CC=\"${cwsw}/muslstandalone/current/bin/musl-gcc -DUSE_MUSL\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-stripping \
      --enable-native \
      --enable-multiarch=no \
      --with-incdir=\"\${t}/include\" \
      --with-libdir=\"\${t}/lib\" \
      --with-linker=\"\${s}/bin/\${m}-ld\" \
      --with-assembler=\"\${s}/bin/\${m}-as\"
        YACC=byacc \
        CC=\"${cwsw}/muslstandalone/current/bin/musl-gcc -DUSE_MUSL\" \
        CFLAGS=\"\${CFLAGS}\" \
        LDFLAGS=-static \
        CPPFLAGS=
  sed -i.ORIG \"/define MUSL_DYLIB/s|#define.*|#define MUSL_DYLIB \\\"\${t}/lib/ld.so\\\"|g\" os/linux/ccconfig.h
  sed -i.ORIG \
    '/^OBJS = /s/^OBJS = .*/OBJS = crt0.o crt1.o gcrt1.o crti.o crtn.o crtbegin.o crtend.o crtbeginS.o crtendS.o crtbeginT.o crtendT.o/g;s/-fpic/-fPIC/g' \
      ${rname}-libs-${rver}/csu/linux/Makefile
  unset s t m c d
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"${cwsw}/muslstandalone/current/bin/musl-gcc -DUSE_MUSL\" ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install CC=\"${cwsw}/muslstandalone/current/bin/musl-gcc -DUSE_MUSL\" ${rlibtool}
  local c=\"${ridir}/bin/pcc\"
  local v=\"\$(\${c} --version | awk '{print \$4}')\"
  local i=\"${ridir}/lib/pcc/\$(\${c} -dumpmachine)/\${v}/include\"
  local t
  cd ${rname}-libs-${rver}
  env CPPFLAGS= LDFLAGS=-static \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CC=\"\${c}\"
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  test -e \"\${i}_off\" && mv \"\${i}_off\"{,\${TS}} || true
  mv \"\${i}\"{,_off}
  for c in \$(find \"${cwsw}/muslstandalone/current/\" -type f -name \\*.o) ; do
    find \"${ridir}/\" -type f -name \$(basename \${c}) | while read -r t ; do
      mv \${t}{,.ORIG}
      ln -sf \${c} \${t}
    done
  done
  unset c v i t
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

if [[ ${karch} != x86_64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"${rname} only supported on x86_64 for now\"
}
"
fi
