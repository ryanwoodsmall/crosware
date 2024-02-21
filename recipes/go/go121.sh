rname="go121"
rver="1.21.7"
rdate="20240218"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="23e7443479ced56f4b76c3f849550282ffd9ea8c539c989de262a93fadf5a1a8"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="bb1695128bdfd846d01a85d1717fd6aa6e4c84d7c6a56948ce58d6a30c62d43f"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="8bbc7e2658c27779931242188a84dde9e9dea98fbab59f5a6ef5618b2a286efb"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="bb5b914f88f4bca0c78f9fd78197511b7ef2cc74b653b5ca6b818da7f957b2b9"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="e936cc793bcae716ffe766bef23cf6d47ec79d84d2741c277006c60b5e94b897"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
