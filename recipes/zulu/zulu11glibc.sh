rver="11.68.17-ca-jdk11.0.21"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="5638887df0e680c890b4c6f9543c9b61c96c90fb01f877d79ae57566466d3b3d"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="22b77de4bc46abd9b5463068ccd33e05d9ce6dd6fffb99dfab03e8c6d071b685"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="e0a8e9d8a8f5bab7caeab347fa9934761de79cb91967a9f8582f901b6b606eda"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="725aba257da4bca14959060fea3faf59005eafdc2d5ccc3cb745403c5b60fb27"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
