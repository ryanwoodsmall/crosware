rname="go119"
rver="1.19.3"
rdate="20221120"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="c3dd66d600f2a1b87d7ce17455a8ec45b270086699666b06406dd6d8dfaabc2f"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="d125bfe2fd278987e3d3b2612fc3854f090ba7ae161f57db8067e0de063497f2"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="35c5112efdc06ea2157c14245a9b86d8a08e4b666621efea1ee9d1397c85d27f"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="6d394d2d7e6d5d9d5029072364357e2e47d9708b1f1a214d822e6c9fbf98cf6c"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="37fc682fcdf1a8dc3b3cb6fffbf2ab2cecc48aac3f2c18ae90e026dd15d3095e"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
