rver="17.68.203-ca-jdk17.0.20.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="7512b062d1ca3e43eec9fa8c83bbd525c93fa6ab618ee7f391931847a7619705"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="d6c73e707810169099fb793e87341f829603e2063569f2ab2fbf73302f0c1bc1"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
