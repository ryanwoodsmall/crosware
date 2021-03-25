rname="tinyemu"
rver="2019-12-21"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bellard.org/${rname}/${rfile}"
rsha256="be8351f2121819b3172fcedce5cb1826fa12c87da1b7ed98f269d3e802a05555"
rreqs="make curl openssl libssh2 zlib nghttp2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i '/^CONFIG_SDL=.*/d' Makefile
  if [[ ${karch} =~ ^(aarch|armv) ]] ; then
    sed -i '/^CONFIG_X86EMU=.*/d' Makefile
  fi
  if [[ ${uarch} =~ ^(i.86|armv) ]] ; then
    sed -i '/^CONFIG_INT128=.*/d' Makefile
  fi
  sed -i \"/^CFLAGS=/s|\\$| \${CPPFLAGS}|g\" Makefile
  sed -i \"/^LDFLAGS=/s|=|=\${LDFLAGS}|g\" Makefile
  sed -i 's|^bindir=.*|bindir=${ridir}/bin|g' Makefile
  sed -i 's/-lcrypto/-lcurl -lnghttp2 -lssh2 -lssl -lcrypto -lz/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  make install
  ln -sf \"${ridir}/bin/temu\" \"${ridir}/bin/${rname}\"
  ln -sf \"${ridir}/bin/temu\" \"${ridir}/bin/${rname//tiny/riscv}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
