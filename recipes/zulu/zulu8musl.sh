rver="8.84.0.15-ca-jdk8.0.442"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="6511fb534bfaf500dfb11df3100a8408b0f30d92e34750ac2dede5428d58761b"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="a146df9e25addc948085651f83b1eb72d10e7b368539e4e57859c81fb2c48976"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
