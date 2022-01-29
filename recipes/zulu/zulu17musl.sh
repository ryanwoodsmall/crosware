# default is x86_64
rver="17.32.13-ca-jdk17.0.2"
rsha256="bcc5342011bd9f3643372aadbdfa68d47463ff0d8621668a0bdf2910614d95c6"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="6b920559abafbe9bdef386a20ecf3a2f318bc1f0d8359eb1f95aee26606bbc70"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
