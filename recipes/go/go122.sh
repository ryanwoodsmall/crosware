rname="go122"
rver="1.22.6"
rdate="20240809"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="100f87412e91d4eab852e402e550d34d1dd1851340c49ab728094dc6b2d015cb"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="bc981b57c4d535759ae24ab64fe30a5dc12990c40a92bc8d115c3d0d663a8432"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="cc98dd5785fbb238f3bd10671bf62ae9f7f94452f8a9df8fa1480f8a78c53155"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="0b4913ae347fb5073663cbb803a3eddd3423635104764ae67028ae27fd4ebdd4"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="f10db0aa735c3f7cce2aa572be1e55cb01eb5856ee2e44ce7b301f99f5f00263"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
