rname="kind"
rver="0.20.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes-sigs/${rname}/archive/refs/tags/${rfile}"
rsha256="6795c3478a298973e010349b87740fa1732e18989856db0deed54b153330365c"
rreqs="bootstrapmake go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 bin/${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
