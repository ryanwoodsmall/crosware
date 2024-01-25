rver="8.76.0.17-ca-jdk8.0.402"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="9a1bd8fdb8606455a6c5e30f740238aeff05c0f9a96caabd2efc4c66903eab8c"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="b37ec65ad5ca241f5cb1d0f65929af7be4230b8bf18cfa1b131bae946ecf4def"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
