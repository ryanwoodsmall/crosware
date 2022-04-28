rver="11.56.19-ca-jdk11.0.15"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="fc7c41a0005180d4ca471c90d01e049469e0614cf774566d4cf383caa29d1a97"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="1c637012c5fce079a820ab3cc8b74695722c10e07342336055042aebb8bd8420"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="1ee1654aa592f48ce2920092638d70bee4b6997dc42cf629a9717fb11e468d58"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="e064b61d93304012351242bf0823c6a2e41d9e28add7ea7f05378b7243d34247"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
