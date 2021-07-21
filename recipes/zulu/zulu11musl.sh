rver="11.50.19-ca-jdk11.0.12"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="231073c8c07c8aa4044abcfabe28e28ee9f5eec513a5da59e87d1f6ea41fa7f8"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
