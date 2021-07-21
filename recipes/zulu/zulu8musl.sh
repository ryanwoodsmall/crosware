rver="8.56.0.21-ca-jdk8.0.302"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="9484132a535e349a7bde77a9ea1cad16f229e86837154c0da91d2ab689d47cac"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
