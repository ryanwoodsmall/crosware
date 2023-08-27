rname="go121"
rver="1.21.0"
rdate="20230826"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="289e5b7bb930f64d06b880758e69aff35afba6601db2f7bd0afea0720699e2c2"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="4f1206c48531dbcaf53904d39ca0d60965c93a7315b14e1e57f57fc009ae3cda"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="4354f9724ec0ff55a59aac2897b00a43bee0b4caec576d3380b046db6032f36d"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="111d39471273c851558a3d9d73506eb7447b93ba2037020b2a55fea9d06b866e"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="154473d8943f7f03ca37edf99a9620f4fef806c30dd742b800d4ae56c2da5059"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
