rver="21.48.17-ca-jdk21.0.10"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="16a73c4c66c730a0d46384816fb38e9751cbcbef49e24409690b1795d0aebaad"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="9009c15c3359a35a88fe6a6358b996f32b2c8155d83bb561a2c4d202a60e322e"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
