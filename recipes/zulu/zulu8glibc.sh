rver="8.66.0.15-ca-jdk8.0.352"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="80d22ddd0dfac0562580cf46bb55f9539e61f7fd8df5f8464a1c83eb9dec24bf"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="326d1a2d1fe79e3589e68e9af299a00cfe528006c2de89a1ed8a63cc1aeadbd7"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="4c2f52f43aae28c70c44064382db062f2cf55dd22d7aeb960f56e5c5873c4720"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="a3987f9bd87a3930f2e9cd679990e7b702c8f912a77d08a24163debbfc51bf51"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
