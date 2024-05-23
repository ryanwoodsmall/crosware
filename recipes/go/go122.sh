rname="go122"
rver="1.22.3"
rdate="20240523"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="f5cb05c33e5d582812084401b3b087ffedcbe81eef22f613eeb6067aecc38e27"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="e556ccf20c0339edfd91da16dea5504d5365ae6731507e096bff209c3e883659"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="e8d18766acdb4ef0f4227986ea46109a358b559d8b3d4b20f152a048829dd68c"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="31b6609dd5ee6ae1daf24342ea48fb7279744c2165a3a6b7890add6ecc7a1acb"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="ccd671b06eeca8a3b70ec0e2702203804ce78e1c4b84e2671e765333a0aa7b5b"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
