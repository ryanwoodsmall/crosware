rver="8.70.0.23-ca-jdk8.0.372"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="6316c35f570a81fcf6dbf7b00e172694e6745bba8ce6693c82c42a130cf1068c"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="9405532a17ec56195a43b9c27157584b3ca3f0a3275b99e4df0a2bbebf2a5628"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
