#
# XXX - very ugly
# XXX - x86_64 only for now, weird errors on 32-bit arches, aarch64 not supported
# XXX - pcc-libs patch: https://git.alpinelinux.org/aports/tree/community/pcc-libs/musl-fixes.patch
#

rname="pcc"
rver="20191207"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="ftp://pcc.ludd.ltu.se/pub/${rname}/${rfile}"
rsha256="95b554c148888431f751c7cd120ebdd2c8084300214274f195077b3d668ca91c"
rreqs="make byacc flex configgit"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  local f u d s
  f=\"${rfile//pcc/pcc-libs}\"
  u=\"${rurl%/*}-libs/\${f}\"
  d=\"${rdlfile%/*}/\${f}\"
  s=\"ccd064b1efa868128c1734ea45421c98936a93d08affde878ecc06a04c91e8c6\"
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
  local t=\"${cwsw}/statictoolchain/current\"
  local m=\"\$(\${CC} -dumpmachine)\"
  local c d
  for c in config.{guess,sub} ; do
    for d in . ${rname}-libs-${rver} ; do
      rm -f \${d}/\${c}
      install -m 0755 ${cwsw}/configgit/current/\${c} \${d}/\${c}
    done
  done
  env CPPFLAGS= LDFLAGS=-static \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-stripping \
      --enable-native \
      --enable-multiarch=no \
      --with-incdir=\"\${t}/\${m}/include\" \
      --with-libdir=\"\${t}/\${m}/lib\" \
      --with-linker=\"${cwsw}/statictoolchain/current/bin/\${m}-ld\"
        YACC=byacc \
        CC=\"\${CC} -DUSE_MUSL\" \
        CFLAGS=\"\${CFLAGS}\" \
        LDFLAGS=-static \
        CPPFLAGS=
  unset t m c d
  sed -i.ORIG '/define MUSL_DYLIB/s|#define.*|#define MUSL_DYLIB \"${cwsw}/statictoolchain/current/'\$(\${CC} -dumpmachine)'/lib/ld.so\"|g' os/linux/ccconfig.h
  sed -i.ORIG \
    '/^OBJS = /s/^OBJS = .*/OBJS = crt0.o crt1.o gcrt1.o crti.o crtn.o crtbegin.o crtend.o crtbeginS.o crtendS.o crtbeginT.o crtendT.o/g;s/-fpic/-fPIC/g' \
      ${rname}-libs-${rver}/csu/linux/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CC=\"\${CC} -DUSE_MUSL\" ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install CC=\"\${CC} -DUSE_MUSL\" ${rlibtool}
  local c=\"${ridir}/bin/pcc\"
  local v=\"\$(\${c} --version | awk '{print \$4}')\"
  local i=\"${ridir}/lib/pcc/\$(\${c} -dumpmachine)/\${v}/include\"
  cd ${rname}-libs-${rver}
  env CPPFLAGS= LDFLAGS=-static \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CC=\"\${c}\"
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  test -e \"\${i}_off\" && mv \"\${i}_off\"{,\${TS}} || true
  mv \"\${i}\"{,_off}
  unset c v i
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
