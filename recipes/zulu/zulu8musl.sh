rver="8.58.0.13-ca-jdk8.0.312"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="defdb7336fd83cde094c5f971832c0ba378f6dc7443b224bb60afe10640dd466"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
