rname="minikube"
rver="1.30.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes/${rname}/archive/refs/tags/${rfile}"
rsha256="e23fbb1fc3028370968f5bf4777aacbeb7e1fd3d2e96e7ed090860cedbd62219"
rreqs="bootstrapmake go"

# XXX - ugh
if ! command -v git &>/dev/null ; then
  rreqs+=" git "
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  if [[ ${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='armv6'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64'   ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='i686'    ; fi
  if [[ ${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  env \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    GOPATH=\"\$(cwbdir_${rname})/gopath\" \
    GOROOT=\"${cwsw}/go/current\" \
      make out/${rname}-linux-\${a}
  chmod -R u+rw . || true
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  if [[ ${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='armv6'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64'   ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='i686'    ; fi
  if [[ ${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 out/${rname}-linux-\${a} \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
