#
# XXX - uses a github commit, download every time
#

rname="simh4"
rver="a06fa9264f5efe1deec362e03ec571cbec0d98be"
rdir="${rname%4}-${rver}"
rfile="${rver%4}.zip"
rurl="https://github.com/simh/simh/archive/${rfile}"
rsha256=""
rreqs="make busybox"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  true
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
