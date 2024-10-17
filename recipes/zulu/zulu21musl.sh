rver="21.38.21-ca-jdk21.0.5"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="8d383d47238b44361761edc9e169a215560009b15a0f8f56090583fc4b4709b6"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="b4725425f48138c59e1ee53b59aa5217c5e4571b63d6a801af6809f1e74e95b9"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
