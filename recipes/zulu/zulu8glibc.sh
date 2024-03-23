rver="8.76.0.17-ca-jdk8.0.402"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="fe05eaf0c16e8bc162d9625d26bdf36b4c0445e3349dae149226b89bed0c0511"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="40212ef921979154dbb0e0e502fcd601914912fea9d3aaef946be0f30dc974c2"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="f3cfd84b0d16564f4b176a6c416a7d89d72e5537626bb9083586afbdb938a34b"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="df80c8e8eed3f22a831ec5fadd2df193e04a0eef081d145636fb71a6c9d42449"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
