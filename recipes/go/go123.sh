rname="go123"
rver="1.23.1"
rdate="20240906"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="695dd36e04c6d70b4b151191024d3976a45a23f8b8293b1d7e2b2df3dc2e9c8e"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="01bae1f719ba18c32ced625729bb95a6c1403934e725fa4b5d8c6a46f4abc145"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="3f0978f45be41e2f0c558c5b050297de0aa45e10301dcfd8a1f4a99125d7c014"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="91e1e061785e8cc2dabf9eb56cf79053575453e247069ba22e47e1e5d389e865"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="dd2b6a685fd143fdd85f89e093a4dccfb7748d178aeeb860e21c3d6d930bab28"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
