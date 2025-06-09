rname="go124"
rver="1.24.4"
rdate="20250609"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="4b831ff20269f3b8dfe8047e363b0dd492a1395b7511b6d479e5d626c3c0e4a2"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="e9e8a9d13f137328f9fab994665d5192f77ce4de880cc27190f097d1f94eed9f"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="6d7070f689998d922286e1fc395fec28a4a8b8a918bd61327a9402bfa9c29039"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="d1242f2331c788f6085c05ee2f4c9812506330dff14fe8869323dc8fe95a45fb"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="2782d36b92e52336522f53f06d33b2c3a0f89d977db1e064c5ae66c706cb8e10"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
