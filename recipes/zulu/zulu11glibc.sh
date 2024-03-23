rver="11.70.15-ca-jdk11.0.22"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="bba5d6317000ad484c31bea3dca14e864231a55611d6860b17459d7bbfed2349"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="d354e784a533291bc8deb73613105ccd43295c714981f708315f0a11adc6f4e0"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="e48c8060de5d4c4e2c1be476fcc57f22c77df3195ecdeba3049674d9922491a7"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="578d5946b26d9257b78e82a1c28203e5bbd690de48e2016399b1274c3ee7a3c5"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
