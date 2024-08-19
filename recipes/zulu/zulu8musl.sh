rver="8.80.0.17-ca-jdk8.0.422"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="1ece1bc32d70257e26c733ae7dee522b3935cdc7c0ee4167ffb45c66b52cff8d"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="7e29ac70506a7760d9efa39daa71e2efb2caa5dcac75df97cdc4030cedc2d781"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
