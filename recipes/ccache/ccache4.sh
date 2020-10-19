rname="ccache4"
rver="4.0"
rdir="${rname%4}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname%4}/${rname%4}/releases/download/v${rver}/${rfile}"
rsha256="ac97af86679028ebc8555c99318352588ff50f515fc3a7f8ed21a8ad367e3d45"
rreqs="cmake make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch_zstd
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cp \$(cwdlfile_zstd) .
  cmake . \
    -DCMAKE_INSTALL_PREFIX=\"${ridir}\" \
    -DZSTD_FROM_INTERNET=ON \
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
