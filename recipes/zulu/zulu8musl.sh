rver="8.52.0.23-ca-jdk8.0.282"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="51ba720f61e473ca6b31d9677d9b786eca510c593032d1c54f772ee7dda7b9c0"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
