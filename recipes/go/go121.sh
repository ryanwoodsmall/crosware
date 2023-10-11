rname="go121"
rver="1.21.3"
rdate="20231011"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="9e4669100d6b1df9eca6a13672847b22e4307c99b22a50a1694d878ab7b32223"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="d1c9fd77471c2792c5316eaf44c896826fbf3759620bbff7243e52b8a7cc7279"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="3ffea8cbe27a113f228283f67b149bade717e7b6e36d108205ada3345ad9a412"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="22cec160e14b4e9a1e28b06531a1f9087d043fdaec767d9d51d2e399773bbbf5"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="2e9db3264bf685571755e251f986ece5e43ba08a02e9a7b6b84c0bfac4fbddd0"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
