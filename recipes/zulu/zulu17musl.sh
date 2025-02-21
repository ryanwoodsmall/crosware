rver="17.56.15-ca-jdk17.0.14"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="84bc1107c5496f52e878091569b511edb04b0ab8217b7a8062fbe2a9ddefa423"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="a34c0c00d78f4bb2fc607e08c40233ea5cbb1284e2268b3936eef64bf7eb2057"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
