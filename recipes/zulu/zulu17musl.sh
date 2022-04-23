# default is x86_64
rver="17.34.19-ca-jdk17.0.3"
rsha256="605bdf70dbe84295c7a4882a365affc246259dd58e4abd351df0ea313d6b6307"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="570704061a8410cd421fcb134e9309324991052600e98c7af1e4274d90cc058e"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
