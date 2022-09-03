rver="8.64.0.19-ca-jdk8.0.345"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="991d08ace913943640dc2f27826a33bd4c4c3eef1950ff7e2b51ebe0ffea05e8"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="2b8fc4a048494244f9b6ccde6a9b89c159f8027ae1b441163c2b13fae9e911b8"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
