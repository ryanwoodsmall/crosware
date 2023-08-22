rname="k0sctl"
rver="0.15.5"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-linux-arm64"
  rsha256="7cc2ab7830700c16f5db9ecb64cf569fc1d4c7ba486c60f7ea0e7f15a1d4838d"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-linux-arm"
  rsha256="26af4fa576f5613d843abc1f29a86bb788fd57e476fb90c0f675cb760c7ee600"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}-linux-x64"
  rsha256="62f70e3f524bd88fa3126eb123ad40ef559e9ca2d0511f8c36fe553a0d33b0c2"
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
