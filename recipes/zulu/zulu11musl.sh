rver="11.66.19-ca-jdk11.0.20.1"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="320a2040afb13e4247c7807c491fba4178297ccb79019f52aef614714b70eb32"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="b1414dbb61b362472ea9636403c92d4b6384e67d8a5392137fc526013fcdec5f"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
