rname="vultrcli"
rver="3.4.0"
rdir="vultr-cli-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/vultr/vultr-cli/archive/refs/tags/${rfile}"
rsha256="966161efc0f65c6f836503dfba9a3e2240ad6e54c76d83817fc99532808cf049"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      GOFLAGS=-trimpath \
        go build -ldflags \"-s -w\" -o vultr-cli
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 vultr-cli \"\$(cwidir_${rname})/bin/vultr-cli\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
