rver="21.40.17-ca-jdk21.0.6"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="f609630f9e0aacecf8027da8b93b3e9a12104874695497f5c01435c3d15a62c2"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="ad6a3fc6be7ba4eec0afb5c9221082db6294722700782c13021e6c99ccefb146"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
