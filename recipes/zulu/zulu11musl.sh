rver="11.48.21-ca-jdk11.0.11"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="406b76e53e8be7e19436dee6954ee903f50c0a2ed3ed86456de4c7b5072aa544"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
