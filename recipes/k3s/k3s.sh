#
# XXX - name contains +, which is urlencoded to %2B
# XXX - don't like + in dir/file names
# XXX - json of channels - "stable" here: https://update.k3s.io/v1-release/channels
# XXX - package for airgap images? k3s-airgap-images-${ARCH}.tar{,.{gz,zst}}
#

rname="k3s"
rver="1.22.4_${rname}1"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rburl="https://github.com/k3s-io/k3s/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-arm64"
  rurl="${rburl}/${rfile}"
  rsha256="86180811cc9a3aad14c68238e90f26df94b71ae308bc871e8d3aa271d931d4d0"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-armhf"
  rurl="${rburl}/${rfile}"
  rsha256="2ae4de4c27b496fc1e807480a95e9967c3af306c754631ad2bc011a8ffaa3ff1"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}"
  rurl="${rburl}/${rfile}"
  rsha256="84bc5241f76d9468c25bb5982624df21ba7f1d6fb142d5986912dca82577d6f7"
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
