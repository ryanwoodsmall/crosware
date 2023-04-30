# default is x86_64
rver="17.42.19-ca-jdk17.0.7"
rsha256="e3028b127e1e655317fd0684d6d2c741a0ba7c3131066727e9eab27a449bac66"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="b9ecf7598c4996dbb7243aecc613a0a6671e647e970f11038e2492f77c4e6f3d"
fi
mver="${rver%%.*}"
rname="zulu${mver}musl"

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
