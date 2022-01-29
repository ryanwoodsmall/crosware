rver="8.60.0.21-ca-jdk8.0.322"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="168f7dbee05a8786ff381810af7b1ea6737e61833703ceca85aaafbd27d5574a"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
