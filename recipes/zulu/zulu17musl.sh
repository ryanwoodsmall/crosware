rver="17.66.19-ca-jdk17.0.19"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="a9cf70d7d2c70fbf424e68326f8963bbbdef14069f5435ded54552d6efe6ed76"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="2f740bbca0fb27017859a5e66d74540b517ac7a6b78b1c5de143c82bc6b64309"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
