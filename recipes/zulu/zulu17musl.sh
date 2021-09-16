rver="17.28.13-ca-jdk17.0.0"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="4de9984e98e6b41d494d2e41b73dbbfc6696f1a5ab83058d569f4e9c3832165b"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
