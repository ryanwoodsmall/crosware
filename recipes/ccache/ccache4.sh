#
# XXX - redis backend requires redis (duhhh) and hiredis
#

rname="ccache4"
rver="4.7.1"
rdir="${rname%4}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname%4}/${rname%4}/releases/download/v${rver}/${rfile}"
rsha256="fa00c8446d910acebd10dc43e7b77e3b78e774ac3f621618e8d055dcc631e914"
rreqs="cmake make zstd"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cmake . \
    -DCMAKE_INSTALL_PREFIX=\"\$(cwidir_${rname})\" \
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local c=\"${rname%4}\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  make install
  strip --strip-all \"\$(cwidir_${rname})/bin/\${c}\"
  cd \"\$(cwidir_${rname})/bin\"
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
