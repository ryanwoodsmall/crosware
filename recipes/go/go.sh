#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#
rname="go"
rver="1.18.2"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="9755b0b95667ed6fefb9503df3e14c549a10a86893bf27df70b7ec3682614a48"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="472648a5bf2ae14bce376e6f897f18d6dc56dfe88ec9dd94cfde122521922022"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="698dd5a8e481b6842c9457ba137ab9213d719d0848bb74e1e0eb8294c563d149"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="f1bbd276eb9af5e01b09bdef4172b9c3c70654f0955f5b7824142c2bb993ffa8"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="${rname}${rver}-riscv64"
  rsha256="e740bd3ba8824c5dc620161ea21f9f30e02881278a9945d1103e08f0f759395f"
fi
rdate="20220511"

. "${cwrecipe}/go/go.sh.common"
