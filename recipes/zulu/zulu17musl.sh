rver="17.54.21-ca-jdk17.0.13"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="166ff0cdcc072a021e0dbdd19cb6be55afb9180f98e467dd6cab173b70186474"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="c66ad1e20c226785eb0a9fa0bd81598bd564fab49ed1391c73f2bb3d7894f343"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
