rver="8.56.0.21-ca-jdk8.0.302"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rver="8.56.0.23-ca-jdk8.0.302"
  rsha256="cc917670e2622dbbc243b6f96c9c199de4ed9e5d541acc68abcb9b378013a38c"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="1934ec9a1d6ea8004fe6448be5d88a00a59774407f8774538ec34d52abeaa531"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="e8775ed63daf12e4c481d4a26b3b849e0caefc5ecec3534c2de18df72d1662aa"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="f6e6946713575aeeadfb75bd2eb245669e59ce4f797880490beb53a6c5b7138a"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
