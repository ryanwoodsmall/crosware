rname="gotoml"
rver="2.0.7"
rdir="${rname%toml}-${rname#go}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/pelletier/go-toml/archive/refs/tags/${rfile}"
rsha256="e3add1ec1c2f00af3478d361b36f8ae598fbcca978d04dbd2aa2dfc12904083c"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  for p in jsontoml tomljson tomll ; do
    cwscriptecho \"${rname}: building \${p}\"
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o \"\${p}\" \"\$(cwbdir_${rname})/cmd/\${p}/\"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  for p in jsontoml tomljson tomll ; do
    install -m 755 \"\${p}\" \"\$(cwidir_${rname})/bin/\${p}\"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
