#
# XXX - very ugly
# XXX - x86_64 only for now, weird errors on 32-bit arches, aarch64 not supported
# XXX - pcc-libs patch: https://git.alpinelinux.org/aports/tree/community/pcc-libs/musl-fixes.patch
# XXX - need to replace .o startup files (crt1.o, crti.o, crtn.o) with the ones from muslstandalone
# XXX - symlink here, cp may be better?
# XXX - use of musl-gcc path precludes ccache
#

rname="pcc"
rver="20230603"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
#rurl="ftp://pcc.ludd.ltu.se/pub/${rname}/${rfile}"
#rurl="http://pcc.ludd.ltu.se/ftp/pub/${rname}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="aa715e621432914efc02bfe47b4ed3dc38325f8676704090378b823cb127c0e3"
rreqs="make byacc flex configgit muslstandalone"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  local f u d s
  : f=\"${rfile//pcc/pcc-libs}\"
  f=\"${rfile//${rname}-${rver}/${rname}-libs-${rver}}\"
  : u=\"${rurl%/*}-libs/\${f}\"
  u=\"\$(dirname ${rurl})/\${f}\"
  d=\"${rdlfile%/*}/\${f}\"
  s=\"436b526b047a5273c95a5a3879eccdf113e679b4eeaec869a4443520bfaf24cf\"
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
  pushd \"${rbdir}\" &>/dev/null
  local s=\"${cwsw}/statictoolchain/current\"
  local t=\"${cwsw}/muslstandalone/current\"
  local m=\"\$(\${t}/bin/musl-gcc -dumpmachine)\"
  local c d
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
  sed -i '/^CFLAGS/s, = , = -I. ,g' ${rname}-libs-${rver}/csu/linux/Makefile
  sed -i 's,CFLAGS,CFLAGS_EXTRA,g' ${rname}-libs-${rver}/csu/linux/Makefile
  unset s t m c d
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} CC=\"${cwsw}/muslstandalone/current/bin/musl-gcc -DUSE_MUSL\" YACC=byacc ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
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
  test -e \"\${i}_off\" && mv \"\${i}_off\"{,.\${TS}} || true
  mv \"\${i}\"{,_off}
  for c in \$(find \"${cwsw}/muslstandalone/current/\" -type f -name \\*.o) ; do
    find \"${ridir}/\" -type f -name \$(basename \${c}) | while read -r t ; do
      mv \${t}{,.ORIG}
      ln -sf \${c} \${t}
    done
  done
  unset c v i t
  popd &>/dev/null
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
