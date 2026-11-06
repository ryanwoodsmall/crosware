rver="25.38.109-ca-jdk25.0.5.0.3"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="7c9022e72566eb0dc2ad178c83e318a3f587d6b724ce47758e4efa78fef2de83"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="cf10352da83ff2faad04166fee22008e8c691e6f906885a56065ee8d5ab247e9"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver

# vim: set ft=bash:
