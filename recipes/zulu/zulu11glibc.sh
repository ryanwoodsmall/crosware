rver="11.64.19-ca-jdk11.0.19"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="edfea52958b765732e4ee97b821e78d6ebf66a69fc21bdf6035c38b0e2939820"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="89e633988881975cd4715f4208c165545e7776372d927d352d5df0e4929be0a6"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="80ce9d9eb1dcd313b2393fa847f244b69af50f08fc0e38ad7b66cc845ee1f455"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="8b963105ad195c8f622b34dbac663ce11e5f73f4c84edd6dd1d364a26798b540"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
