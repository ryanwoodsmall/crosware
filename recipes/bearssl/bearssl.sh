rname="bearssl"
rver="0.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bearssl.org/${rfile}"
rsha256="6705bba1714961b41a728dfc5debbe348d2966c117649392f8c8139efc83ff14"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} CC=\"\${CC} -Os\" LD=\"\${CC}\" CFLAGS=\"-Os \${CFLAGS}\" LDFLAGS=\"\${LDFLAGS} -lc -static\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/include\"
  cwmkdir \"${ridir}/lib\"
  strip --strip-all build/brssl
  install -m 0755 build/brssl \"${ridir}/bin/\"
  ln -sf \"${ridir}/bin/brssl\" \"${ridir}/bin/${rname}\"
  install -m 0644 inc/*.h \"${ridir}/include/\"
  install -m 0644 build/lib${rname}.a \"${ridir}/lib/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
