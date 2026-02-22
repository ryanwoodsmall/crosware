rver="17.64.17-ca-jdk17.0.18"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="4b986596d52550eec0b33a33db4c7974c09a2a404eb08e2e1a948cdab2d1a96c"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="03974f94cfa1d37f7d258dca5215a8aa2c9d10fc7559aa5a97191ae7a78b7c3c"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
