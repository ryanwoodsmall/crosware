# default is x86_64
rver="17.30.15-ca-jdk17.0.1"
rsha256="02764bb49dc7e1a01bfa3b99ba7cc20ca8403dc41e914d1a5ae43a32eb25f7b1"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="74e9ffa86b8cf7757501794b847133502f33d916ce07a07171317bcf97c646f1"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
