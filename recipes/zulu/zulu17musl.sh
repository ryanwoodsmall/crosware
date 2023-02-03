# default is x86_64
rver="17.40.19-ca-jdk17.0.6"
rsha256="a068c520146b92bfee08f0f7e995db7a17e35ae5e10fe664efcd13b393e2496f"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="110ac9284426f16f2616c4457b809d10f6f08c7017b6a257aa865f6bb08c83d7"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
