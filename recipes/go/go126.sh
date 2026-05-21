rname="go126"
rver="1.26.3"
rdate="20260521"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="a6fb0ad882f8b523d824ed0eda3e09d0627082cf9ba161d3c89c01dd9f479fb1"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="cd4d5410e8b9f56ef6f638062cf6bd6637df389ab17c0059969d1d2c59af66fc"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="ffac0442a018675e6c66b8cde11d25cd1c352fafdac032132aa69c49210b5577"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="86679e5094cc34e6f93b07864030f894c5afa4bde919e012a4c578760d0a4967"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="c22f8202ed39e5ed1f7daf37741eb24426ac18c354b9dccc25b3fd528eb77e60"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
