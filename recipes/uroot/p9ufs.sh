rname="p9ufs"
rver="6f4f11e5296eca26bcb7a7a3b44197723ce82bee"
rdir="p9-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/hugelgupf/p9/archive/${rfile}"
rsha256="756dd80a438971bd4516815ed54f0c9734618ccc78a58f95ac20cf666037d9b9"
rreqs="go cacertificates"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    export GOCACHE
    export GOMODCACHE
    export PATH=\"${cwsw}/go/current/bin:\${PATH}\"
    cwmkdir \$(cwbdir_${rname})/bin
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -o \$(cwbdir_${rname})/bin/p9ufs \$(cwbdir_${rname})/cmd/p9ufs/.
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/bin
  install -m 755 \$(cwbdir_${rname})/bin/p9ufs \$(cwidir_${rname})/bin/p9ufs
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
