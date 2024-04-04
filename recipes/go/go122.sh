rname="go122"
rver="1.22.2"
rdate="20240403"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="413ef121a94c248618984eccb7baf0f637324c7a602cb3b53db945ad316f33b2"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="a0cc03075a1c8d9e3e02ec7584731e1e7d05a63e7283e92d2a2459408d947fa7"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="ee609e8fc7c0e3634654f432145685422e51e4a43d41f58c0add7c3044cbb015"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="bc3086711e96a28d1b79a1f7fa15f038f55c5679c76420947c781708275332e5"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="cb73348d3011c803638aadcbf5c390e520ce41f199b66690823a09a53110cc8d"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
