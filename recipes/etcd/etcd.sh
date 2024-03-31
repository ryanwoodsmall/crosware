rname="etcd"
rver="3.5.13"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/etcd-io/${rname}/archive/refs/tags/${rfile}"
rsha256="3cbbc0690f518300782bc572a1c89d085c4b5482bfcba57b2f2ecec0f4d40db4"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 bin/${rname}* \"\$(cwidir_${rname})/bin/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
