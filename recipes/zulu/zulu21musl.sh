rver="21.54.109-ca-jdk21.0.13.0.3"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="26eb0368ceae1277381968830c4df30afbfe9c46aff9c5d980ab415d7d317bc9"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="9e0e1869d1de64709170b49671a04d61c3c9995155aeb596145e28310c3f9922"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver

# vim: set ft=bash:
