rname="go124"
rver="1.24.1"
rdate="20250325"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="e3a8f44280e15d39df04892f31372377bbc0fc7c487edee7037b8f9429c478eb"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="dc9b7bf4f3b1898d601a859a06b56a3789fec864e29675b32e5a051b0e11f68f"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="3ce7fe91357b8b49f573930271e4ae2ee6e9666f753b458edb9317305cecb21f"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="894f4c522363cfd8ad8e94d9613911b209488a009c79f049b952f91d9b3a3a66"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="92b1c8042a70393be9af62ac3a69aabf75b8b5274dc8a07321c299066d6ec2a4"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
