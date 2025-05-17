rver="21.42.19-ca-jdk21.0.7"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="02dbdaf6e31c1dd767953615e2928cd33f2935715f715fa181283f373c3c47ad"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="e1fdd8ceb0297d1480581296bcf88088377fe49a9b49c847eb6e5ab759940da0"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
