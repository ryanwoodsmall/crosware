rver="11.54.25-ca-jdk11.0.14.1"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="b0fb0bc303bb05b5042ef3d0939b9489f4a49a13a2d1c8f03c5d8ab23099454d"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="1521a4e5f18df362715a171d2be2a553306d573c9b958ec39a366cd8c4b8398f"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="0627ee047246dec575e919bdc2d6a6c94bf6b8a9b332a9964222bd326c5950d1"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="60e65d32e38876f81ddb623e87ac26c820465b637e263e8bed1acdecb4ca9be2"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
