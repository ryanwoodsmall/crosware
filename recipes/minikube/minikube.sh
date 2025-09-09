rname="minikube"
rver="1.37.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes/${rname}/archive/refs/tags/${rfile}"
rsha256="4e85cc93888d943fc9f98d62e99f60e754e98c3b18e29a33b75d0b65591e5dfa"
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
  sed -i \"s/go 1\\.24\\.0/go \$(cwver_go)/g\" go.mod
  sed -i \"s/go1\\.24\\.1/go\$(cwver_go)/g\" go.mod
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
