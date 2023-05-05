rver="8.70.0.23-ca-jdk8.0.372"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="c76da27e2cd5c396d72633baf27edd17031d87e5cb6c8620255dcd0384e61afa"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="612684905c546ecfa8b203bd0d739ce5b63762243b090deb00fe6b35577df6f4"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="9ab5b252a8287a39f2cddac9c5d931e5179a4e2f298de5060d2ee2e76868c017"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="afcda0f08cd05efd3bd60b021618931595ab03689f1c1fefcd46ef7761276d10"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
