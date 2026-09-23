rname="etcd"
rver="3.7.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/etcd-io/etcd/archive/refs/tags/${rfile}"
rsha256="5f5bfff6886c47ac841f46097b30f9aae917e918adf158d0b81042d078af93d0"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    cwmkdir \"\$(cwbdir_${rname})/bin\"
    for s in server:etcd etcdutl:etcdutl etcdctl:etcdctl ; do
      d=\${s%:*}
      p=\${s#*:}
      cd \${d}
      env \
        PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        GOCACHE=\"\${GOCACHE}\" \
        GOMODCACHE=\"\${GOMODCACHE}\" \
        GOPATH=\"\$(cwbdir_${rname})/gopath\" \
        GOROOT=\"${cwsw}/go/current\" \
        COMMIT=\"\$(cwver_${rname})\" \
          \"${cwsw}/go/current/bin/go\" build -v -ldflags='-w -s' -o=\"\$(cwbdir_${rname})/bin/\${p}\"
      cd \"\$(cwbdir_${rname})\"
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
  install -m 0755 bin/${rname}* \"\$(cwidir_${rname})/bin/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
