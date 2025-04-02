rname="go124"
rver="1.24.2"
rdate="20250402"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="9107d00b0c706fd7263b8ca345f972c9d7d30eaae22a97ae87e8d4ffcd2e6b3e"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="b838d7347f993767bba27312a38105ccaf39a80aa8cce1f0b63d7f09c90abefe"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="207e656022db79894c4e50b3ad3a3c9678dfb7598665a7ff7e380ce88958db86"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="d0ce4027ef4622511785a58e92ff9c6542408b1a46ac174e96da7d75471cea92"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="156401d5be66f268682b014e82a6d3bccf20b70b174d1d6cd129d27c0e1e04ca"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
