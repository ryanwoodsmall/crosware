rver="21.50.19-ca-jdk21.0.11"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="297d77b64c9b3acc4f7654fa81a2db14a05e1194185f3a2d4ec3c8f54e4ed455"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="9cc7e0e689b6b0de57fc09607cf32eb8280e4250c5882290444f09927b18b532"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
