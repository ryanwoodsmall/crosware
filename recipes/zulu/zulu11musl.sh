rver="11.60.19-ca-jdk11.0.17"
mver="${rver%%.*}"
rname="zulu${mver}musl"
rsha256="c88f438c07a38fb49b8a3a0a3cfd152dd09c24158ac43b024c72ebcfbe31124d"
# per-arch override rver/rdir/rfile/rurl/rsha256 here
if [[ ${karch} =~ aarch64 ]] ; then
  rdir="zulu${rver}-linux_musl_aarch64"
  rsha256="17ee2eb126a15b489a397f14440a3740594bb139a9ddd506dfcc4101cdb4e014"
fi

. "${cwrecipe}/${rname%${mver}musl}/${rname//${mver}musl/musl}.sh.common"

unset mver
