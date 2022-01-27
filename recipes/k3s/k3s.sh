#
# XXX - name contains +, which is urlencoded to %2B
# XXX - don't like + in dir/file names
# XXX - json of channels - "stable" here: https://update.k3s.io/v1-release/channels
# XXX - package for airgap images? k3s-airgap-images-${ARCH}.tar{,.{gz,zst}}
#

rname="k3s"
rver="1.23.3_${rname}1"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rburl="https://github.com/k3s-io/k3s/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-arm64"
  rurl="${rburl}/${rfile}"
  rsha256="0a370a4f148c2a5fdd6164f3636d3dfffbc2173f9c39476b7b6d017ae94752da"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-armhf"
  rurl="${rburl}/${rfile}"
  rsha256="671b6522dbe8acbaefa27063bc2709200391795d4743ba15361dd95b6ba9f595"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}"
  rurl="${rburl}/${rfile}"
  rsha256="2c74eff75d10660815e47d90d258b6edce5a817942fb0f7cfbebcb976628612f"
  rdlfile="${cwdl}/${rname}/${rfile}-amd64_${rver}"
fi
unset rburl

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(i.86|riscv64) ]] ; then
  eval "
  function cwinstall_${rname}() {
    cwscriptecho \"${rname} does not support ${karch}\"
  }
  "
fi

for f in extract configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${ridir}/bin\"
  install -m 0755 \"${rdlfile}\" \"${ridir}/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
