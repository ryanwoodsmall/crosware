rver="25.32.21-ca-jdk25.0.2"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="6967ef9e52cde3f3efbfe03a44572c4c5419edfb3165ac3da359381765763475"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="d4688425cf2e315f000213a8917f93a5ff4e1b818c50b24f682e189424932a39"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
