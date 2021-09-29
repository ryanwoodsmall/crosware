#
# XXX - redis backend requires redis (duhhh) and hiredis
#

rname="ccache4"
rver="4.4.2"
rdir="${rname%4}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname%4}/${rname%4}/releases/download/v${rver}/${rfile}"
rsha256="357a2ac55497b39ad6885c14b00cda6cf21d1851c6290f4288e62972665de417"
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
    -DREDIS_STORAGE_BACKEND=OFF \
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
  for p in cc cpp c++ gcc g++ ; do
    for a in ${statictoolchain_triplet[@]} musl ; do
      ln -sf \${c} \${a}-\${p}
    done
    ln -sf \${c} \${p}
  done
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
