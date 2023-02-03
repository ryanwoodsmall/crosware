rver="8.68.0.21-ca-jdk8.0.362"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="81af591bf76e62d7cf39dc9bb7ea4c57014ef87f4af5e2b0e61c118a651b0064"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="595d55110674b169994f2bf6366dc70c660353dfc6108cca7f122bef437ea21e"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="a34e3817ce709cb3fc0bd1f9a37c8c22b1392a2a91b108464c09bf20ee6dbb62"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="f65abb149f2b53305eb578647552506307982bd443aba37ac7c761b1c7d620df"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
