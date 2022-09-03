rver="11.58.23-ca-jdk11.0.16.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="6f6e2cbf71982a5540c83c77441e3b26e7706672e7e8dd8a7e473b8825832db6"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rver="11.58.25-ca-jdk11.0.16.1"
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="e82a555db6a9a19433a1f2589d86a429b191dbe25e12550e8f801f9a84237239"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
