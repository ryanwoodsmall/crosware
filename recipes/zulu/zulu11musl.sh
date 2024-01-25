rver="11.70.15-ca-jdk11.0.22"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="992d0cfb6c00eefd35e6f22e6b235dff9aeaaf9dc234728ce09e24986906772c"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="18d0989836f76002c8b0cb251a2ddb6b2e7da9168af713fed3e5d86149af7f6a"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
