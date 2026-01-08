rname="go125"
rver="1.25.5"
rdate="20260108"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="5a53e3114043e72fe090418828c87d6d98b9d18982ea35363ea37e2106c65ecf"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="caee04ac915cbce0fecccc91b56eb42d325cfcf43120e80ee4359232f7a9bd25"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="3e19e417d3b93895038326128b1b0771bb5a212a9aa8140992c5d5bedf522c5a"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="15fc59b00c106aa44583997801c2c39c5b02f3421f297edb8c66f4e4399af294"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="657735cc8db6217f57b6824699b9df3685ad75adac9c588bd326906c9e64a799"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
