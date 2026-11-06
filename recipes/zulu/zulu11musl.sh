rver="11.92.109-ca-jdk11.0.33"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="2946c47ac9aab714e58d9bacdf89cbcb8d8954d5fb7e3e91eb9a42b3d0f8ee2b"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="94f1094f921c30a7176f9e72fc950add3e6bf0b34d41177e78443acfceb40b2a"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver

# vim: set ft=bash:
