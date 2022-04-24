rname="etcd"
rver="3.5.4"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/etcd-io/${rname}/archive/refs/tags/${rfile}"
rsha256="10e8c1604578d4a8557263d61d4fbbd2428c8cd8dda3c8a23a8755314af6ef10"
rreqs="go"

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
  for s in server:etcd etcdutl:etcdutl etcdctl:etcdctl ; do
    d=\${s%:*}
    p=\${s#*:}
    cd \${d}
    env \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      GOPATH=\"${rbdir}/gopath\" \
      GOROOT=\"${cwsw}/go/current\" \
      COMMIT=\"${rver}\" \
        \"${cwsw}/go/current/bin/go\" build -v -ldflags='-w -s' -o=\"${rbdir}/bin/\${p}\"
    cd \"${rbdir}\"
  done
  chmod -R u+rw . || true
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 bin/${rname}* \"${ridir}/bin/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
