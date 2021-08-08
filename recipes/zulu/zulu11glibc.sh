rver="11.50.19-ca-jdk11.0.12"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="61254688067454d3ccf0ef25993b5dcab7b56c8129e53b73566c28a8dd4d48fb"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="d947879ce086631918fd420a5576bdec8e7183700fd50461ebf078a6d8611b5e"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="d063cb6c0f4f5530d30073894baebb7475801e865ea83915e78017f88d84fca0"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="b8e8a63b79bc312aa90f3558edbea59e71495ef1a9c340e38900dd28a1c579f3"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
