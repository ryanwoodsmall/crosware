rver="11.76.21-ca-jdk11.0.25"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="ba6e0f01faf6695a7cb46e563b9ad5bef39b1846564c81658194b9eabaca873d"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="1b125d126680cfa7bd1261c2471b5998ca22455a36a5cfd8ac70c6df8d6bb0f9"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
