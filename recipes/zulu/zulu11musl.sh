rver="11.54.23-ca-jdk11.0.14"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="250622e83688ac2e66cb1379a00dc47708f9fbde757056329e45ac4391db14c4"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
