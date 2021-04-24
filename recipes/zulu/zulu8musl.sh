rver="8.54.0.21-ca-jdk8.0.292"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="34e6841c9ae66729f72aad39c59af75dbae86f778c32048304d7e74ed39e2d4a"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
