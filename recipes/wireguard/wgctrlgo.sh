rname="wgctrlgo"
rver="97bc4ad4a1cb712d87f5ccf4d4a62b1cd42574ab"
rdir="wgctrl-go-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/WireGuard/wgctrl-go/archive/${rfile}"
rsha256="e3dbe21f04a91cb1d402d2ccb82b27c6d0786a6dc9cd095ea12caa4b38bee2d0"
rreqs="go wireguardtools wireguardgo"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  test -e \"${rbdir}\" && chmod -R u+rw \"${rbdir}\" || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  env \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    GOPATH=\"\$(cwbdir_${rname})/gopath\" \
    GOROOT=\"${cwsw}/go/current\" \
    CGO_ENABLED=0 \
      go build -o wgctrl-go cmd/wgctrl/main.go
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 wgctrl-go \"\$(cwidir_${rname})/bin/\"
  ln -sf wgctrl-go \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf wgctrl-go \"\$(cwidir_${rname})/bin/${rname%go}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
