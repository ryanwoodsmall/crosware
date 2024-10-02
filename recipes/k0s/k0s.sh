#
# XXX - k3s notes apply here too
# XXX - package for airgap images?
#
rname="k0s"
rver="1.31.1_${rname}.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rbfile="${rname}-v${rver//_/+}"
rburl="https://github.com/${rname}project/${rname}/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rbfile}-amd64"
  rsha256="740f525440e125ae5123e17f4d634230b5a6a82d8562b740b6c2cf329603cd1e"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rbfile}-arm"
  rsha256="0011d563018660647d273535cc19463906041abf86a29182c6e61b89f59cfce4"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rbfile}-arm64"
  rsha256="e0c2edc3d6d749b18368c22f8ea048eb858debd7091270a738ccabdae90b7c32"
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
