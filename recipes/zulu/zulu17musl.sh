rver="17.50.19-ca-jdk17.0.11"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="22bbde6e05ced1238b302e2b44d3f9785c23e4115618eea83786b6b4a1828f9f"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="fc6645aa46736e6100302c109127ea31a1d1192599b7140dd94f81eaeebfe293"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
