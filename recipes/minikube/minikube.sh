rname="minikube"
rver="1.33.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes/${rname}/archive/refs/tags/${rfile}"
rsha256="c09715a884ffc9af49772e579d1932bdd0377c3346a5631d48ae23453ba6945b"
rreqs="bootstrapmake go"

# XXX - ugh
if ! command -v git &>/dev/null ; then
  rreqs+=" git "
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

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
    env \
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
