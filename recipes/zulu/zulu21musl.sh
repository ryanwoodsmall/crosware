rver="21.44.17-ca-jdk21.0.8"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="fb33a162f97691ef2ab35acfb898fa8f16980f3249919967acdfc87fa61542ab"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="4c093acf4cdb5efc31dbe4377b925f3eaacfdfc3dc9319ac9b108638da033c30"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
