rname="goyq"
rver="4.47.1"
rdir="${rname#go}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/mikefarah/yq/archive/refs/tags/${rfile}"
rsha256="48ef09b9ffdb80f26ee516fa2fc83f713c1b49f503cedef79a96435509d456af"
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
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o \"${rname}\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname#go}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/go-${rname#go}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname#go}go\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname#go}-go\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
