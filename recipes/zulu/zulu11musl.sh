rver="11.74.15-ca-jdk11.0.24"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="66506abe3ad3473a9c895c7c8d3d2468cde0aae4a6680cf505cbf9361d183df6"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="648ae914681c9c9dd63ee105c92b654e0af533a4fd922da7d6f7023a3098991a"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
