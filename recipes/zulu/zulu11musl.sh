rver="11.45.27-ca-jdk11.0.10"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="efc94aa65985153c4400a86bcbb8d86031040fd0a8f6883739f569c3a01219f8"

. "${cwrecipe}/${rname%${mver}musl}/${rname%${mver}musl}.sh.common"

unset mver
