rver="17.32.13-ca-jdk17.0.2"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="2b8066bbdbc5cff422bb6b6db1b8f8d362b576340cce8492f1255502af632b06"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="ca2f80d1d84f4da8e6c8cbadf809f9554b7e628d064088e51e5d2afcaf42619e"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="582611374e247ff751da7cf806413fdc5f765648b25f25c5e68fa287003f6a9a"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="73d5c4bae20325ca41b606f7eae64669db3aac638c5b3ead4a975055846ad6de"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
