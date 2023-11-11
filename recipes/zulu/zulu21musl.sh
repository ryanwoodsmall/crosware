rver="21.30.15-ca-jdk21.0.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="57949162ac0b9c15d4b4cc85b0f9df0b06481f957089f94a4c245ef23c56c097"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="5276a0877691559fb870246de5f836c863717f15c0458ebec1473384d3a1136f"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
