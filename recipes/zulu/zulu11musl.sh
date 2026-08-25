rver="11.90.205-ca-jdk11.0.32.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="54e010980f549ed33db8732ac09f188c52d3b67f51e941345c3a48a855682b9d"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="9bf3379f31570732db3f71fe386fd8c492e2dd8095584226e989160d000690c5"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
