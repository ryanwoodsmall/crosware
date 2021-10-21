rver="11.52.13-ca-jdk11.0.13"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="194400dafe8892f86ab00922304e4df5ac77c14c3de7c91901aa4f6eb5c8a7c9"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
