# default is x86_64
rver="17.38.21-ca-jdk17.0.5"
rsha256="26fb05c19cddc5eb1e08b9654da4e4c56abb7e971a592f787f991d46e9c8dbb5"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="7bc1b91fbfca5e6211ba9333dae235fdc1ada2df7681ef41761dc0900d633974"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
