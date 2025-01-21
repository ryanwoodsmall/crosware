rname="go123"
rver="1.23.5"
rdate="20250120"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="4a043d1dd33bc882fdb714f3009885ab061fbc59ee11616cb0b313cca15d6f37"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="98595a4b3ee3d06bd06faba4536e6dbcd609a9ca56a30cd12ceb068c7ddcc587"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="d6cf4b8bf81f493525c86c99069c51bbf04b174441ebc8ee4f357957b52c8e5b"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="ed08f0e20e48af4045581173b6f0535534d01589ab3fc53de18c5f44102b24b4"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="c94e3780d6cd0c9f5212312ca635ba022e17e51ee4f64f02a550ffda53495947"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
