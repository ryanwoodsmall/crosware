# default is x86_64
rver="17.36.17-ca-jdk17.0.4.1"
rsha256="918d9f3a41e3feecc73502b62b5a0cb492dacfc95fedf21120cc38b315fded9c"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rver="17.36.19-ca-jdk17.0.4.1"
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="862c2400bd96911f6cc846a62288cdc6dd2491d3b73db7c6d08f8be1121ac478"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
