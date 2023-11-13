rname="go121"
rver="1.21.4"
rdate="20231112"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="86fb72b169fc0fe5cc1f062fe791c208d3bbd9997742746ca9534f9520d694ab"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="1203a7279e04fbe7bf849164c9d77b561aa86e5b0c82867c77bc6ae10586ad2a"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="0caad606a464244fc043c75b4f61eadf267e0d3a5f547f9bfd934a0836c5cca5"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="b3519dcc10d7b0cc5e065d4c6bc98e3e10cdc1d0413afaa22b129bddd5d2f24a"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="1c6557f6a352156aac3cc682f9cc4c01f8bac4bb4de9f6f26d0b4c46e4af9c16"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
