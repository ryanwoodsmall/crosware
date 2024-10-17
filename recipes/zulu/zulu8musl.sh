rver="8.82.0.21-ca-jdk8.0.432"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="cf0e6dc30166a232726fd16e87657c9789661e0ce63c4dbf3c8cdaed26b910d4"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="14891aebd67c4a0edccca2166f4ffbcae59ab16366eac9e9f381a98c4d4c178a"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
