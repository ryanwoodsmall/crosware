rver="21.36.17-ca-jdk21.0.4"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="7b66607f99193d8c7fe47a4caaecb52d74c19edefc947939c1594b4e258c6015"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="d1a06f0eaedfda80fd222ebe6083a1dc044f6092f8a9fb244c7dd831499eb52e"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
