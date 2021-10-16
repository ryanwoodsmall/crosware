rname="etcd"
rver="3.5.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/etcd-io/${rname}/archive/refs/tags/${rfile}"
rsha256="499c3adca699199981cd46e1267dccdd4c34bbc111fc9166dc555cbf9ca91918"
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
