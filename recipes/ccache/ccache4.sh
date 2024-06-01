#
# XXX - redis backend requires redis (duhhh) and hiredis
# XXX - fmt requirement in 4.10+, need cmake w/curl or to manually include it
#
rname="ccache4"
rver="4.9.1"
#rver="4.10"
rdir="${rname%4}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname%4}/${rname%4}/releases/download/v${rver}/${rfile}"
rsha256="12834ecaaaf2db069dda1d1d991f91c19e3274cc04a471af5b64195def17e90f"
#rsha256="16972ba62c8499045edc3ae7d7b8a0b419a961567f5ff0f01bf5a44194204775"
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
