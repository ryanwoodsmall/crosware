#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#
rname="go"
rver="1.17.9"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="72588b76af44dbf76036913fd4fdc0a21e2d48c4e3bae3cddb1652784e605cf3"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="2a6f8cf3090a7531adaa8caf1f9538386a26e449c4fda0ae0316cd416c609f0e"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="87869de80803494b67cb151288393bc02a7ff97f3d2d437a91945d6e5d29a220"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="c8d6fca9f798ce42cb030cec8dda9ff5313d73051d02dfcfc15d12e0480f0045"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="${rname}${rver}-riscv64"
  rsha256="c59a474ae0e8239eb27f3cbb447b53655eef0ecf3bbfc666ed517bd410917a7a"
fi
rdate="20220427"

. "${cwrecipe}/go/go.sh.common"
