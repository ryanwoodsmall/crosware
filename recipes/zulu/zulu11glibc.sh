rver="11.66.15-ca-jdk11.0.20"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="54174439f2b3fddd11f1048c397fe7bb45d4c9d66d452d6889b013d04d21c4de"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="0caac5eceb50040296ddff231048ed600bdd9f7818899ca72b9e7f0175b95315"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="0589901c9311cfa570961a88717aae058b5839f3aef17bd98692f4b2e273292d"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="a34b404f87a08a61148b38e1416d837189e1df7a040d949e743633daf4695a3c"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
