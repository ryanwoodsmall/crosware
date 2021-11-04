rver="8.58.0.13-ca-jdk8.0.312"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="a3e9f7cfe55eb9ed9dfd87e38d61240c8bbf8543125ff9ae905ffb73bc625e06"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="04691ef8019671849eacd197587315439cf5df4a1c24cb757f83e0e5c0a9400c"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="3718a47bb272c93a3eb0cb9a44ec571aa95799ca6e0f998e668aec6ef925744b"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="73417488fa4b7f7f8c0c5940dabea87908b29a23e1ee6c948b2f0ca8b9af231d"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
