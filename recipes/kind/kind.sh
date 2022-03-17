rname="kind"
rver="0.12.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes-sigs/${rname}/archive/refs/tags/${rfile}"
rsha256="cd1d09921b3c8a0f58c6423e5706be0c6e556f0c3d2b9e62f42be59263b209bb"
rreqs="bootstrapmake go"

. "${cwrecipe}/common.sh"

# XXX - segfaults on compile/link for riscv64, problem with my go? qemu? cross-compile problem?
if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  cwmkdir \"${rbdir}/bin\"
  env \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    GOPATH=\"${rbdir}/gopath\" \
    GOROOT=\"${cwsw}/go/current\" \
    COMMIT=\"${rver}\" \
      \"${cwsw}/go/current/bin/go\" build -v -o bin/${rname} -trimpath -ldflags='-buildid= -w -X=sigs.k8s.io/kind/pkg/cmd/kind/version.GitCommit=${rver}'
  chmod -R u+rw . || true
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 bin/${rname} \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
