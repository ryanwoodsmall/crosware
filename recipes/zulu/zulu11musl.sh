rver="11.56.19-ca-jdk11.0.15"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="2179fa2d2b3016c36793e2c84de53185d2177bf2c572de0177334277f4a5e536"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="fcb46f70726fec697dd9628f686ccc62cb8efdeb680a653d3e36f9ba354ba3d6"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
