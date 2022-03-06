rver="11.54.25-ca-jdk11.0.14.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="06b1855b5ea44407940bf2a85bc2094dc7fccd561a5058c87c57c9f1a3caff65"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
