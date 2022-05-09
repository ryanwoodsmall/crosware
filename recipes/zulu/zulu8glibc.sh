rver="8.62.0.19-ca-jdk8.0.332"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="c4519172d6f5323192561108ee25c2cdef2b7ab0d7f9c807d95a7cf5d4209e84"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="cc775897116405bc8405e8b7db444d9b2e4e4aaaa8bcd7ff8b2a2b87758cd6c3"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="9a755765d58e4d8ab14cf080a206815c7070cc719086f1fe41a22cdbf1374b05"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="bfe6fa049797ea996e5a7252279f4bb99d5e8f2227be6c3b98e9c78e3d916fc9"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
