rver="17.42.19-ca-jdk17.0.7"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="c37caf7e2dc98ede2613a83be0bf712c5a4a8429753f0c83411be55e0f5e5fd0"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="25f48e8d4a339f7346eb7884fa0c040911c86113b361a0c6787d28627cae09c2"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="53a66b711d828deae801870143b00be2cf4563ce283d393b08b7b96a846dabd8"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="28861f8292eab43290109c33e1ba7ff3776c44d043e7c8462d6c9702bf9fffe0"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
