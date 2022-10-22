rver="17.38.21-ca-jdk17.0.5"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="dbc6ae9163e7ff469a9ab1f342cd1bc1f4c1fb78afc3c4f2228ee3b32c4f3e43"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="55f936d1b067bfc760ae5682f563ac79dd93a31d0042e04c77bac11f62dacf0b"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="4468c90b5c98b1d2989703617a3101fbe8b44234c7e7aed6b1de3394356e4345"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="20c91a922eec795f3181eaa70def8b99d8eac56047c9a14bfb257c85b991df1b"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
