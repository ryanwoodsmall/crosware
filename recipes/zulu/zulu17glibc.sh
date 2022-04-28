rver="17.34.19-ca-jdk17.0.3"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="693f6c6784db21b44646504c702d999515a9e937bccb47eaf420e366ccb1c4b3"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="4be413e4af150f29b3f868ad8a8f0e3ef0b51e389a6433430e351439c8a06573"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="1c35c374ba0001e675d6e80819d5be900c4e141636d5e484992a8c550be14481"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="caa17c167d045631f9fd85de246bc5313f29cef5ebb1c21524508d3e1196590c"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
