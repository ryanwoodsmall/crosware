rver="21.32.17-ca-jdk21.0.2"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="ec8ca330eb65c626f9045414ec1646970a66e9afa8a8d91f8db8d5d5b0e18d51"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="418bef47fea1e55fcd1bee0fbc7eae876b8b160a868857c5e16a082669505144"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
