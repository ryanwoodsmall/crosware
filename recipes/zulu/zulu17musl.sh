rver="17.48.15-ca-jdk17.0.10"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="2e6d14c4d4c18e148fa91da5a522492a1a0dd6dd2c1882e06d93799fb88d1508"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="994e72800cd7312560699b9638ee55cf6a5ee49840b761b220b0e34a90849727"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
