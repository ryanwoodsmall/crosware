rver="8.78.0.19-ca-jdk8.0.412"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="c1028010a26e6fdc2366c977f692fbf82a00b6464c9adfad4d33f26dbc4870f8"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="c4875abbf3c0963c0d5db88e00dcc04f95d94a25331c6a68d927e9af106040c3"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
