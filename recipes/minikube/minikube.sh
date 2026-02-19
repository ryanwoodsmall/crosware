rname="minikube"
rver="1.38.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes/${rname}/archive/refs/tags/${rfile}"
rsha256="f3401ff708235441d12ee47f5e8b5e7f55e7944585ae2a9bdb4b8cb629838f7c"
rreqs="bootstrapmake go"

# XXX - ugh
if ! command -v git &>/dev/null ; then
  rreqs+=" git "
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat go.mod > go.mod.ORIG
  : sed -i \"s/go 1\\.24\\.0/go \$(cwver_go)/g\" go.mod
  : sed -i \"s/go1\\.24\\.1/go\$(cwver_go)/g\" go.mod
  sed -i '/^toolchain /d' go.mod
  cat Makefile > Makefile.ORIG
  sed -i 's/export GOTOOLCHAIN.*/export GOTOOLCHAIN=local/g' Makefile
  sed -i \"s/^GO_VERSION .*/GO_VERSION=\$(cwver_go)/g\" Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    if [[ ${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
    if [[ ${karch} =~ ^arm     ]] ; then a='armv6'   ; fi
    if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64'   ; fi
    if [[ ${karch} =~ ^i       ]] ; then a='i686'    ; fi
    if [[ ${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    export GOTOOLCHAIN=local
    export CGO_ENABLED=1
    env \
      GOTOOLCHAIN=local \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      GOPATH=\"\$(cwbdir_${rname})/gopath\" \
      GOROOT=\"${cwsw}/go/current\" \
        make out/${rname}-linux-\${a}
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  if [[ ${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='armv6'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64'   ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='i686'    ; fi
  if [[ ${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 out/${rname}-linux-\${a} \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
