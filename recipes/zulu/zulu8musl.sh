rver="8.96.0.205-ca-jdk8.0.504"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="1f376ac138a1b9598e283f3d7929640aa3235a8ec6e46d00fa81a141057aaf3b"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="e4fd7cb5444cb5d076eb74bf6e69cc5abd4c7dff57673e076270c2e7da39f486"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
