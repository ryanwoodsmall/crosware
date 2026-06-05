rver="8.94.0.17-ca-jdk8.0.492"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="946ec697296df31f8791ffb6e67607095dbc5da6e05e78e5c4847ed291fca49c"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="7bc4eb6c6338a5c48f88eae97b42abae715907eca80ca45ffec22e82866129dd"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
