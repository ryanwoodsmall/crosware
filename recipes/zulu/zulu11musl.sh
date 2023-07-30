rver="11.66.15-ca-jdk11.0.20"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="8a54827da4f3aaac7c7e321ccdc45edea7e4d995297daab6ce89081d51ab2d05"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="f674a9d2d72d366c7bd9b4947dada0478d41a28d8b9a97946e2946c028e884b2"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
