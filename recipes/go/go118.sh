rname="go118"
rver="1.18.6"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="8e26b91f26582450af8d7e649b3fd20f8e0c6f2c5bcba134e27d14b805ec624d"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="c1b12b239626eac0036f0466458434a49b1e421b836ffd66be8175134089970e"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="a7ace67d6fc7f50b714abdc90a425a6d8a588151de575758c9ac4fb9ff68b020"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="fad2f037a612fd479d65ad46a751b876e20d7ff3109f8d87073c1846d0aafccc"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="96e52cfb3d1fdf5f71c9b65e36f1def11dfe4e577876be892d846b0ebb511e30"
fi
rdate="20220910"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.19.1/${rfile}"

. "${cwrecipe}/go/go.sh.common"
