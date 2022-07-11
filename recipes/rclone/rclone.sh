rname="rclone"
rver="1.59.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rsha256="01b2aa4f6dfafcda11026a5aa024dd86ae6bd337fa54269dfac97c80fe280d7a"
rreqs="go"

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  chmod -R u+rw \"${rbdir}\" || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      \"${cwsw}/go/current/bin/go\" build -x -ldflags '-s -X github.com/rclone/rclone/fs.Version=${rver} -w -extldflags \"-s -static\"'
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 755 ${rname} \"${ridir}/bin/${rname}\"
  install -m 644 ${rname}.1 \"${ridir}/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
