rname="k0sctl"
rver="0.17.2"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-linux-arm64"
  rsha256="3881f10f5dd887f2e2b2fe74b00f5fe3618ed8c85f6949c83e87a4cadb7341fa"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-linux-arm"
  rsha256="223d755d21d25c759936bb55663b79ef3a9cd0e9e8c7881c5097650790fc559f"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}-linux-x64"
  rsha256="bda0fddea3c5e560f7c4da1bed8a42798797dcaa39c8e38f521ad3b54974482e"
fi
rurl="https://github.com/k0sproject/${rname}/releases/download/v${rver}/${rfile}"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(i.86|riscv64) ]] ; then
  eval "
  function cwinstall_${rname}() {
    cwscriptecho \"${rname} does not support ${karch}\"
  }
  "
fi

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export DISABLE_TELEMETRY=true' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
