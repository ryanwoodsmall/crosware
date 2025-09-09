rname="cpu"
rver="31103c0229b62ccb5a48453daa9a765e7a802c5c"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/u-root/cpu/archive/${rfile}"
rsha256="2fcf9d1fec3dd0b8e3957fd40f1552d6f36330f1e308712abcb811a1942274bf"
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
