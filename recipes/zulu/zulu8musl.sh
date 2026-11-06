rver="8.98.0.107-ca-jdk8.0.512"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="aa39c0e1662d32c6cf7f61ba5afa3c715990a4c3d618ae0e796f79409f441154"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="2a6f4140ed53df3687c7e4ca9e0d5492b4a0ece494fc59b57d999ee10990854d"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver

# vim: set ft=bash:
