rname="go126"
rver="1.26.5"
rdate="20260709"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="9165bb4cb3868a402e746ffe3619a10fc699113c01c457d167263c16c7ef1c5c"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="e1564834b541c18105c25a8e99a15f8904c9f14ed1c83370e212f16168c8fe86"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="5af96ea6cffab8fdf226347c99eddfba573c3ebe60f4c43f4f1379def714d2f7"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="3d7277511673a32aaa1b17dc677cd4d9d2b3d06661b6af54a8722006c3b424ba"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="f317bfaf5d386752ed67ca9849b38ea1a4aefe25e6d0597dc62262a86fb53de7"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
