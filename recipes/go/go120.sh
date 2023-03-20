rname="go120"
rver="1.20.2"
rdate="20230319"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="35bdca1274eb7c3073e064237097c33db82874f0faab0012337abdef9b85ec27"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="6b9e0cc8d9c2c44d4792a5e75b4b55d5b96626d0ba95ace0023324a7058eb47d"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="0fe737d963b2fc3803b57c32974bb7c1a4372711c9c25564fe567f76625cbace"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="55448e0c18ce240e036210eca16946c1b13defd2c8ea6744a2b667942100a311"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="564661dae777164de73bda4b8adca7f0a213f7e6d631eb3d3379d257db5f6b41"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
