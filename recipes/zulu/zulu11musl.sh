rver="11.78.15-ca-jdk11.0.26"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="d8d0162f577d8f3150de0eca223184e78bd966125c1877f976c9a60ab7c491ed"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="cb5087e0faca648097d1facfdd7081ae55641268c5df8405fa40d6686ab6d5ec"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
