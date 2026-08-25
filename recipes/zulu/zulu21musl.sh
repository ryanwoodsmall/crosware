rver="21.52.203-ca-jdk21.0.12.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="f2b26df82d22910cdd7e5171517edbc10e5fc22657bfe85dd0aa75cbdaec01fd"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="b86c81b74803128389de2421cbf94eff193418505d6e9ac97e6d0ee160ec25d6"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
