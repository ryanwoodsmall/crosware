rname="go120"
rver="1.20.3"
rdate="20230411"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="98ddf4bda5741777be5800d60e18f1590335d33b32194d3084e0c9b0f9ef464e"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="7af45a8737ff3f7b93c6cf808d6a09838e1499565afcf7ec04ec122eaf8478e6"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="13aa829be2a356533c101d5682dec3840e1b731ec027a439e915a596df5f0f85"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="8e354e89072ceeede5e54eb18cb02fbbf17d74ad736463090eb1cebc81fefb49"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="6269d29d7fd764588a9b2182906aca94b3f956de47ef6f3f80f7ca3dd4b4b7a0"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
