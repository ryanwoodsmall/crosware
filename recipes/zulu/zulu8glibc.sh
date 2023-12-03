rver="8.74.0.17-ca-jdk8.0.392"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="c4449d28499f92213ae7b5ffc5c970b0947933e3fbd81a5612bb4071831c2b46"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="9d7c46b836094ea5b805eda88a79e19171d7256130a6968e2324da838b546217"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="bf49bdeae46ecba5035eac8790c9ac0521bfbf3393389e9a432d658abd71e26b"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="39dc809ef8e88eff49d2eaeb48580729888486d56d846559b719da9c545e2884"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
