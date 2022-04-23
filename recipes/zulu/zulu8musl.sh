rver="8.62.0.19-ca-jdk8.0.332"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="62ba8f2fb152dd3a04bc8b0ea89ecf076da46779744f7997fe2720796a68c625"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
