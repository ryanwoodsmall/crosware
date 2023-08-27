rver="8.72.0.17-ca-jdk8.0.382"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="bde61dd92b47baf9c9a15461c365765ae825b5e6e37602014c457b5be6f7b428"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="0732ba76e39efd72e605f2af30714df442f82dd63a1ba054d1b42ec8693f0e55"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="13d44f00a96221a5f486c38a32d6f8a2e407d3d391993db1eea4c2eb9c7d2a66"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="7b15a56f2ae005beda0f875a269b3daad14ffa12969306cc745478385b25ba96"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
