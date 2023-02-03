rver="17.40.19-ca-jdk17.0.6"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="d0720ee2367a43112015b1aab0907e5c31c208f50335090f49b20c8f7a72587a"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="a2d9d7b734174fd734700194d8e38434f24a62be193c4c2810ba1a91efd4c5e4"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="7466df603829fd075298181c2a3adb11aadffa134746b9bb96e69c44e1844a3e"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="2867572c5af67d7bf4c53bf9d96c35977eebdfdbf26202c2dc7a1acbbea3f6b7"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
