rver="11.72.19-ca-jdk11.0.23"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="7cf25f2e6cef9337a4b7c70dc876e217460b2aabe0f24f087bd3ebb616efcee7"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="69e4164183bd62b36d1d1b6e56fdface3a020a5116f67632e80a468c7f256cb2"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
