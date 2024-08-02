rname="go122"
rver="1.22.5"
rdate="20240802"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="d4c38f5d643b1e8afb2c2dd6df5e347dc735148a0ef506c500fb90c02ab7134c"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="ca4e575036ffbf1204abc2900aff5258a2a9d4127f5a56a04ce6555fe4c2430c"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="5790c9e6444b05f4b65cb838867e6780ca6fa5ef75eaa9fd6475e51586baecfb"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="69a28fc7e4b08f8b310010ef1670428f3cab886f2bd2ca4abad8e6f820d06b98"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="172f549d9d3b50b33b1ac78d63caddfe1ad170d0dde518109f900aa4a3124bde"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
