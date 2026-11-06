rver="17.70.113-ca-jdk17.0.21.0.3"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="09e5b1e9bb63c9444d674883850e22f2eb3e198303fec4dfa85ba8251091a4e1"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="33d146a2d372aff6b742bda4742e29aa4e737eb8004c69a752852c59173871af"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver

# vim: set ft=bash:
