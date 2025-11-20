rname="go125"
rver="1.25.4"
rdate="20251119"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="f5eb1f90d920b32b89ec697768f4b9d93ec807012dc9813e980b3f4c8b2adc2c"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="1b398d747b8870477e139d94e1d9fb88ac55063a4734ac6484e42d546fcbb6cd"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="3368ab09801b0a9ec7dcfbfb5b456a9f628c7cd9b67e897d2654ec9ef202ee92"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="6184c748f7434b22c5cffe3b4b1ec8b2a5c7ab592d5506e668e9023078e081b7"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="c52894473cd39a14c1f5b4fb6ccc79b6df20ffb981dbd5a4a7bc344a6f9972ab"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
