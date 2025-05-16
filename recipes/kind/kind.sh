rname="kind"
rver="0.28.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes-sigs/${rname}/archive/refs/tags/${rfile}"
rsha256="2dda606263fca917f505c3b0b4e0857b1663d88d34b5c7cda6dfa8f32d4754a8"
rreqs="bootstrapmake go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    cwmkdir \"\$(cwbdir_${rname})/bin\"
    env \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      GOPATH=\"\$(cwbdir_${rname})/gopath\" \
      GOROOT=\"${cwsw}/go/current\" \
      COMMIT=\"\$(cwver_${rname})\" \
        \"${cwsw}/go/current/bin/go\" build -v -o bin/${rname} -trimpath -ldflags=\"-buildid= -w -X=sigs.k8s.io/kind/pkg/cmd/kind/version.GitCommit=\$(cwver_${rname})\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 bin/${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
