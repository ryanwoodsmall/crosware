rver="11.88.17-ca-jdk11.0.31"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="80830fe174482062d67b8cda493b37dc078a6b91f4e42ba631afe1fb90b31ab1"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="a7926cd4a6be4a178b973d8001c095eb35556814bb7ef9600185bc6fca7b3a6c"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
