rver="8.68.0.21-ca-jdk8.0.362"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="cdcf6db607e3218889a45a0507f1439158b53f18921778dfc3be8dd9e6ade8c9"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="d4d5eeedefad7ca46cda005293372e8b53d64d2ce1d1ae57758e21776deef1fa"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
