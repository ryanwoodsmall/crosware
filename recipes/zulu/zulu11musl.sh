rver="11.68.17-ca-jdk11.0.21"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="7124d382540a3f582f2b822aeb10d73e60de6cc83b5fbe2e76bc11ef9473fe6a"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="5457911780bd096dbf0c297157af1fb21f598343c85abb863c7f0856bed26142"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
