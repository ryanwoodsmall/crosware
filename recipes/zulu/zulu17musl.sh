# default is x86_64
rver="17.44.15-ca-jdk17.0.8"
rsha256="f193bf2656cb78986a31365669e6f9f91f2a4beae342e42b6b677664c02d6752"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="87e3bc587092d97f3acdefb53d33e45ab30fb46dbc271bc3c9245d227b1416e0"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
