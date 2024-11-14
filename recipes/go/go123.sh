rname="go123"
rver="1.23.3"
rdate="20241113"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="399a92590aab186d39b504770b438b7ed73e45d9a1aa072430df827cafad39d4"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="1dc0ac5597b92d281f7adbf2dda37f31236dcfd792340eb5c1b95aba5a93464b"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="702b45ca8cd2828592d248a683b974ae2683c30794eee49897101365dc4dd185"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="83ddc31bfe343d99a3bc7395351dc898af32269814db9962c2ea7bde633bdedd"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="325b6a29b851f5df5109e8771879c02c9c9da6e289192ebcb724537af94e6682"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
