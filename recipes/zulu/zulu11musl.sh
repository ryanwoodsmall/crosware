rver="11.62.17-ca-jdk11.0.18"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="2ad14d0dcc5be52d34a60ba7a3b02923c9a5b51eee106ff452ed59527793b636"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="6b84035656305319d0d7c94db9b0493b91c0703d603747e1f6dc7315bf013423"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
