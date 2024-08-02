#
# XXX - k3s notes apply here too
# XXX - package for airgap images?
#
rname="k0s"
rver="1.30.3_${rname}.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rbfile="${rname}-v${rver//_/+}"
rburl="https://github.com/${rname}project/${rname}/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rbfile}-amd64"
  rsha256="623102445b7b7e9e8e25c1a36bcf2f424bcaf7f66643e4842390b2121cb3fcfd"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rbfile}-arm"
  rsha256="f985fc1665c33653be8ec11c7f7b3c4859d2e64d5fb5ea13eb9fe7d8be9e9d19"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rbfile}-arm64"
  rsha256="c7875b761108ca0ca019b6011a5520d8bad377267a5269fcf179de046acf5f95"
fi
rurl="${rburl}/${rfile//+/%2B}"
unset rbfile
unset rburl

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
