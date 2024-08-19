rver="17.52.17-ca-jdk17.0.12"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="1bb9bedde3095d88fd216b9be112b59a8400f0e4d991243ce70be3b0518bcc7a"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="43efd90828038f6dcd941240d7e16719ef091146d137721e66ceefdb6c70ad66"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
