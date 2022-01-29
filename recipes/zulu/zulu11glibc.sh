rver="11.54.23-ca-jdk11.0.14"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="c810e10ebd761ad430746d01404ee4cb5119c104bbd14387b12db7f1b1590403"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="9c419a5321e25f6f9b64c8b456a1cc43f17980afe2396aafa87d9f59df6a5410"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="50b420f9b39eea76244e32e5abb18ae12646e4bddc035b2fdaca8d3cb48d8d52"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="4a7498edc338c84ec99be543dd160b28158a3485896e12e2ad8abcb8f89d1a51"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
