rver="21.34.19-ca-jdk21.0.3"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="b43feb0d2bdbdae7ff5b9427080b3c7b03b7352beebfea2bae7c42fae28020a5"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="22c4ecebe5ebabc0f4c7fca511fd0e7f621c7822abedb89a632d987266f6c73f"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
