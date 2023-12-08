rname="go121"
rver="1.21.5"
rdate="20231207"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="0cf60fb993a152bc66404abe99051953b3e01ad85448ce5e38b21f7ae1927248"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="81442ff2aa088dc6d5fe89e6719851d938fc46d141bd441c282584e5d8349e75"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="2859c998b2e33b288513ab2c210dc9eb3e663bea3d3e379ccbd7719d067d00d9"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="f224f2e731864f044a74a3b7a27f585afc9bc09dc27acbd6590fcb2b39e6b2cb"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="d339f480a2fe12a5c26edd0d1fff3b735d357ac627760656b465a2dab3a1ab9a"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
