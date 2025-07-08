rname="go124"
rver="1.24.5"
rdate="20250708"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="ec3c10036cd02c2023228ead12f0e9a2e96db85e7f275c90f0a7dc8c60230807"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="357ccbe11d722d516556909aa594efd11b48b9d4d57189c2d418f0c990452f72"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="7bb1677b550c144d872e4947ccc3df0e5c719196a733920d5c379f36c9fbbecc"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="4fc032adc69388c83029211b88fb826aba91b61697a879ea3626b6ec64ba22cf"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="5a8aab0954094ae7020b9c55751965ef091c4d53690c4cc4e34d840fad52bd86"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
