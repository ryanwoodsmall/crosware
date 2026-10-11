rname="cpu"
rver="0.1.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/u-root/cpu/archive/refs/tags/${rfile}"
rsha256="22e358401ed321c61bfce955f0952d815e9b979ec3d1b863e64ee83b633f1f24"
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
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -o bin/cpu \$(cwbdir_${rname})/cmds/cpu/.
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -o bin/decpu \$(cwbdir_${rname})/cmds/decpu/.
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -o bin/cpud \$(cwbdir_${rname})/cmds/cpud/.
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -tags mDNS -o bin/decpud \$(cwbdir_${rname})/cmds/cpud/.
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/bin
  install -m 755 bin/* \$(cwidir_${rname})/bin/
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
