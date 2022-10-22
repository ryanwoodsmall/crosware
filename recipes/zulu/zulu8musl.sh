rver="8.66.0.15-ca-jdk8.0.352"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="424e7b72997fddbb1dc519857b9bd1d5574b9a531eab768602c880823b00959e"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="359a2ed589f67a641c79b01efd8e5b7685771434c604bc04ef768eb4a4c64357"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
