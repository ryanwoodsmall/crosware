rver="25.36.205-ca-jdk25.0.4.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="ef121cee9003160bb830a6432b5194eaeb15a43eb7e5a2c2402e343ffe7f464f"
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="6b5bf0a206b36065faaa76517dbdcb332a69af0096da065e8b2cb1dfd5fe0f2d"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
