#
# XXX - k3s notes apply here too
# XXX - package for airgap images?
#

rname="k0s"
rver="1.26.0_${rname}.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rbfile="${rname}-v${rver//_/+}"
rburl="https://github.com/${rname}project/${rname}/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rbfile}-arm64"
  rsha256="0013e20233b5638f9bf77b8faf0100af37f391cb5e01ac0e63fe3c59a704ea3c"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rbfile}-arm"
  rsha256="9dcfaf79850d6d0c93614d5ca882efd4e43399b05ef123fabae5a254d629cef2"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rbfile}-amd64"
  rsha256="33b8946c19b74e045361fadbc3b2140a6f16a74279a73e77ed070045075d418d"
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
