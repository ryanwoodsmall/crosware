#
# XXX - k3s notes apply here too
# XXX - package for airgap images?
#
rname="k0s"
rver="1.31.2_${rname}.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rbfile="${rname}-v${rver//_/+}"
rburl="https://github.com/${rname}project/${rname}/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rbfile}-amd64"
  rsha256="c18dd5a522e98fa943c75f009d0d634ed088bb27606865fb479a94b641512085"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rbfile}-arm"
  rsha256="4f65bde4dc13c47954ad67df1235d1b04c3e9c607261d26c60982e0be275c886"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rbfile}-arm64"
  rsha256="0d1d509b43455f0c8a25322687e0ac8f4b6093833be91c9c1d3308fedeec6ceb"
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
