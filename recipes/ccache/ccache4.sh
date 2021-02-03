rname="ccache4"
rver="4.2"
rdir="${rname%4}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname%4}/${rname%4}/releases/download/v${rver}/${rfile}"
rsha256="dbf139ff32031b54cb47f2d7983269f328df14b5a427882f89f7721e5c411b7e"
rreqs="cmake make zstd"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cmake . \
    -DCMAKE_INSTALL_PREFIX=\"${ridir}\" \
    -DZSTD_INCLUDE_DIR=\"${cwsw}/zstd/current/include\" \
    -DZSTD_LIBRARY=\"${cwsw}/zstd/current/lib/libzstd.a\" \
    -DBUILD_SHARED_LIBS=OFF \
    -DENABLE_TESTING=0
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local c=\"${rname%4}\"
  cwmkdir \"${ridir}/bin\"
  make install
  strip --strip-all \"${ridir}/bin/\${c}\"
  cd \"${ridir}/bin\"
  ln -sf \${c} \${CC}
  ln -sf \${c} \${CC//-gcc/-cc}
  ln -sf \${c} \${CXX}
  ln -sf \${c} \${CXX//-g++/-c++}
  ln -sf \${c} cc
  ln -sf \${c} c++
  ln -sf \${c} gcc
  ln -sf \${c} g++
  ln -sf \${c} musl-cc
  ln -sf \${c} musl-c++
  ln -sf \${c} musl-gcc
  ln -sf \${c} musl-g++
  unset c
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%4}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
