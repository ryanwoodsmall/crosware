#
# XXX - name contains +, which is urlencoded to %2B
# XXX - don't like + in dir/file names
# XXX - json of channels - "stable" here: https://update.k3s.io/v1-release/channels
# XXX - package for airgap images? k3s-airgap-images-${ARCH}.tar{,.{gz,zst}}
#

rname="k3s"
rver="1.23.1_${rname}1"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rburl="https://github.com/k3s-io/k3s/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-arm64"
  rurl="${rburl}/${rfile}"
  rsha256="06564585c4dda211d1dadf8ee960c2cc1f04added3face1f8969174c14bb7a89"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-armhf"
  rurl="${rburl}/${rfile}"
  rsha256="00cac9f92ec200c5a0aaaac6a0ba6c9a7a81bf25c718482ce22ee2b00c1d9248"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}"
  rurl="${rburl}/${rfile}"
  rsha256="78961a7d02995326913e8a03de2209609fae013e1640c4c6e16195460c5f3434"
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
