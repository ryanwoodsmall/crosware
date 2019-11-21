rname="simh"
rver="3.10"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="21718eb59ffa7784a658ce62388b7dc83da888dfbb4888f6795eaa17cb62d7c9"
rreqs="make libpcap busybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/LIBEXT = so/s/so/a/g' makefile
  sed -i 's/ mkdir / mkdir -p /g' makefile
  echo >> makefile
  echo 'i1401: \${BIN}i1401\${EXE}' >> makefile
  dos2unix makefile{,.ORIG}
  mkdir -p sysroot/{include,lib}
  ln -sf ${cwsw}/lib{nl,pcap}/current/include/* sysroot/include/
  ln -sf ${cwsw}/lib{nl,pcap}/current/lib/*.a sysroot/lib/
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} all \
    CC=\"\${CC} -I. -D_LARGEFILE64_SOURCE -static\" \
    LIBPATH=\"\${PWD}/sysroot/lib\" \
    INCPATH=\"\${PWD}/sysroot/include\" \
    USE_NETWORK=1 \
    CFLAGS= \
    CPPFLAGS= \
    CXXFLAGS= \
    LDFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  local b
  local t
  for b in BIN/* ; do
    t=\"${ridir}/bin/${rname}-\$(basename \${b})\"
    rm -f \"\${t}\"
    install -m 0755 \"\${b}\" \"\${t}\"
    strip --strip-all \"\${t}\"
  done
  unset b t
  install -m 0644 VAX/ka655x.bin \"${ridir}/bin\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
