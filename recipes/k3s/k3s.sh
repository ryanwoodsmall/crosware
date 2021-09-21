#
# XXX - name contains +, which is urlencoded to %2B
# XXX - don't like + in dir/file names
# XXX - json of channels - "stable" here: https://update.k3s.io/v1-release/channels
# XXX - package for airgap images? k3s-airgap-images-${ARCH}.tar{,.{gz,zst}}
#

rname="k3s"
rver="1.21.5_${rname}1"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rburl="https://github.com/k3s-io/k3s/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-arm64"
  rurl="${rburl}/${rfile}"
  rsha256="4eae388302e79f443e5478214fa86684d34e0b8d5f36a1849b6e8bcd40229279"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-armhf"
  rurl="${rburl}/${rfile}"
  rsha256="bf11dcc1692072932f823010fbbd30a4c66f3e45540e759a2ede29dcbfeca1ab"
  rdlfile="${cwdl}/${rname}/${rfile}_${rver}"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}"
  rurl="${rburl}/${rfile}"
  rsha256="e75ad28942d7e2db228fd71fdc3b37977e64aa059dbc09cc419e5b0459db471e"
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
