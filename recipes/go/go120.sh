rname="go120"
rver="1.20"
rdate="20230203"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="2b255fc1334f3929e269b9f11c40a912cfd83a4f76864aaff241ff49047f3b34"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="b289479f42645db1a33fdd0b8736bc5bb1283d33396ab9ca8b58098c93c97e35"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="d82ea3cc0ddfa24178eedb9fbb5ca20d93e34630a707b190aa19045561781d07"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="e41fe30ff3ec6cafd6b5f75baae8be14043edb459b3077813a256b39c51f6991"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="317ba95bc2248fe84dca5035c7075449a31b60e680e6c6ebaa45d9408dbd7ec9"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
