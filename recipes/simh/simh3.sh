rname="simh3"
rver="v312-2"
rdir="${rname%3}_${rver}"
rfile="${rname%3}${rver}.zip"
rurl="http://simh.trailing-edge.com/sources/${rfile}"
rsha256="0f2b6e12c4749aee798e201d60bd1e9dd482525a34a44e988208238b3c6e8df2"
rreqs="make busybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf sim \"\$(cwdir_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  mv sim \"\$(cwdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} all \
    TESTS=0 \
    CC=\"\${CC} -I. -D_LARGEFILE64_SOURCE -static\" \
    CFLAGS= \
    CPPFLAGS= \
    CXXFLAGS= \
    LDFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share\"
  local b
  local t
  for b in \$(find BIN/ -type f) ; do
    t=\"\$(cwidir_${rname})/bin/${rname}-\$(basename \${b})\"
    rm -f \"\${t}\"
    install -m 0755 \"\${b}\" \"\${t}\"
    strip --strip-all \"\${t}\"
  done
  for b in \$(find . -type f | egrep -i '\\.(exe|bin)\$' | grep -v /tests/) ; do
    t=\"\$(cwidir_${rname})/share/\$(basename \${b})\"
    install -m 0644 \"\${b}\" \"\${t}\"
  done
  unset b t
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
