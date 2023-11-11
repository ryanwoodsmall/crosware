rver="8.74.0.17-ca-jdk8.0.392"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="e3a3e06a5d605f37b9f235cc0451c0c0f6eca83bd6ce26d9dd48904a3edc5f97"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="332075a5b6c9ede4137424ffbb49aa46b06d5d9f442f603e604ef46fcb23df70"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
