#
# XXX - k3s notes apply here too
# XXX - package for airgap images?
#

rname="k0s"
rver="1.28.4_${rname}.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rbfile="${rname}-v${rver//_/+}"
rburl="https://github.com/${rname}project/${rname}/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rbfile}-arm64"
  rsha256="5650325da83578c64c2ac1f551441e02a5e160142aec11f78127b3c43c5f4bca"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rbfile}-arm"
  rsha256="bc027b8d642d433fe05527b2f75714b6c1b2aaa1718e29a664ab141556cc725d"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rbfile}-amd64"
  rsha256="926bcb68478f0eb5bb8479bf01d39524102346d9f24b9f536aeddf71fdd5a975"
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
