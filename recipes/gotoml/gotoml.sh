rname="gotoml"
rver="2.2.3"
rdir="${rname%toml}-${rname#go}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/pelletier/go-toml/archive/refs/tags/${rfile}"
rsha256="3a5dfdc1e543efd6032813cb27a5b06d66bbefbbcc88bb664f69d605725c42af"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
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
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  for p in jsontoml tomljson tomll ; do
    install -m 755 \"\${p}\" \"\$(cwidir_${rname})/bin/\${p}\"
  done
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
