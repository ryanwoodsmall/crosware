rver="8.72.0.17-ca-jdk8.0.382"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="4c570c3033a1368407078025db84b96131338bfe695037280339e37bf67d382a"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="834a68b52c1eda5acc5376b30eaecfc452f2e7bff9869cbdd6b3846ead143977"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
