rver="11.64.19-ca-jdk11.0.19"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="600cbe8ea898cc6106105b61263db1f10177b935812d0b1678689c45fc179bfc"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="8950727298734f7b8b571a9b9577558e028a738d69005e1ae8e42d2dc0fc4fc6"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
