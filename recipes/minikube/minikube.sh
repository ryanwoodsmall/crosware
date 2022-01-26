rname="minikube"
rver="1.25.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kubernetes/${rname}/archive/refs/tags/${rfile}"
rsha256="406fb9682616a42b56f745648a632399fdc0586f9d06f529764efa43d67ccd8f"
rreqs="bootstrapmake go"

# XXX - ugh
if ! hash git >/dev/null 2>&1 ; then
  rreqs+=" git "
fi

. "${cwrecipe}/common.sh"

# XXX - segfaults on compile/link for riscv64, problem with my go? qemu? cross-compile problem?
if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  if [[ ${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='armv6'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64'   ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='i686'    ; fi
  if [[ ${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  env \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    GOPATH=\"${rbdir}/gopath\" \
    GOROOT=\"${cwsw}/go/current\" \
      make out/${rname}-linux-\${a}
  chmod -R u+rw . || true
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  if [[ ${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='armv6'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64'   ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='i686'    ; fi
  if [[ ${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
  cwmkdir \"${ridir}/bin\"
  install -m 0755 out/${rname}-linux-\${a} \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
