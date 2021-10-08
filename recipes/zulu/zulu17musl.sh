# default is x86_64
rver="17.28.13-ca-jdk17.0.0"
rsha256="4de9984e98e6b41d494d2e41b73dbbfc6696f1a5ab83058d569f4e9c3832165b"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="a3d149f99fc11a7b95c4dd9fc368f779f9262d010c893f44bc0807ef7a98d2eb"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
