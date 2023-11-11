rver="17.46.19-ca-jdk17.0.9"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="e304205f8943e21cc1cdee23b38b59d656c4bc40ad5776f3bdfdb8d7236f96be"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="5d81a82b1a0ae41d1cd63158c433ea4bf56d5e3e7eae6f4eaffbc27d8f3854d5"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
