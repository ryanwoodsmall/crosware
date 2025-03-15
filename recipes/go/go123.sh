rname="go123"
rver="1.23.7"
rdate="20250315"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="1515872b8a89e4c88c04a636d4fb965f210952378f65eced13b30d9876b6e517"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="6c73b13e89255499541d5547f3644248a9a5573ea1fef84255ad7ef4ad3b2e54"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="59d61d79dc9041ae8f0085625821534639bcaa4f92a595a7ac773b3613bc5e0c"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="3aa216b88842b52099a89c1a0ebbe9cdc487c32dd4d4951cead31bae17acb872"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="ac668977608509740cd184895b381a77a91ecd6e2c3f6a2b0e94baa1b395a40b"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
