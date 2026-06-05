rver="25.34.17-ca-jdk25.0.3"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="f0b9cf36db2742e1d8f350bd9884b2d32c6391dd3b2bc9cd10c3c4d4856931aa"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="a19b1c5cad474b6fe7309769da35786f2ca7059c32ce175eddb06148bce85872"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
