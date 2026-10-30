rname="go127"
rver="1.27.3"
rdate="20261030"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="232f89195929a5d2eca033ecb4f2ac7a51e1ae80faa3dc1fa076aa456acbd4a8"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="69e9642f79975f1374e91e52b0c47da976d7176a0598385aacaedc5562b14d4b"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="6de425a5763fed678a2cd71e4595d7529ab2f620b200de41b9a2010bf1eaae93"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="8311af8248d05fced75529f89ef47de008550e513f2f93c1fb116c288ab97cc3"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="c10e7f7fe29f08ff7a7ee1b36f51c738dd9b02658e995fd861f29634018639a4"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"

# vim: set ft=bash:
