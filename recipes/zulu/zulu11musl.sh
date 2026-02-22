rver="11.86.21-ca-jdk11.0.30"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="9afbb76eb84779f3b09a783c431718eef63b08492efeb0afd63e36a0e855a8ae"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="eadf8ba7fe8765945b501722c9dc3c51845c706119fba2f3059d28305b085af2"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
