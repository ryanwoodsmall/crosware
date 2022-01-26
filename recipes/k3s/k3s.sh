#
# XXX - name contains +, which is urlencoded to %2B
# XXX - don't like + in dir/file names
# XXX - json of channels - "stable" here: https://update.k3s.io/v1-release/channels
# XXX - package for airgap images? k3s-airgap-images-${ARCH}.tar{,.{gz,zst}}
#

rname="k3s"
rver="1.22.5_${rname}2"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rburl="https://github.com/k3s-io/k3s/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-arm64"
  rurl="${rburl}/${rfile}"
  rsha256="12f87b7a93b0245e24f931516a895479c7be36b5e7d653c5b7c388fd362b3893"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-armhf"
  rurl="${rburl}/${rfile}"
  rsha256="fc2c81aabbb11ecbdcde1ff3d02b9abd8ed8a3c59b64653f4688bbfd8088ceae"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}"
  rurl="${rburl}/${rfile}"
  rsha256="5f8570b7e3b6420f3dd07d135367a35ac7a77052b4e1c0b42f699fbc194200c7"
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
