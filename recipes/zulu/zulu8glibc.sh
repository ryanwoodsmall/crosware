rver="8.60.0.21-ca-jdk8.0.322"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="0d970a27ac8f33ce70672d193f5ae6af4e5e618f0d3958d99c6d848d20a2c088"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="d2973dd90bac84458b8f87676ee9bd3eddced3fddd11dc3f435945ef379bd7be"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="52c76aa10203cad319d5737076ccadef95ba345cf6a1b097f0358e0683f9b0aa"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="69cac729f07a383aa96e54a669715b3b488130abf8395db1c66cdf82dcbcd54e"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
