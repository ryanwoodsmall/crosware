rname="go119"
rver="1.19.4"
rdate="20221227"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="ec9a84cb8a4d65e89e74e09d8a7f41caa73a17f55703516073875de375ce87c6"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="5d9f1ec7ef4908b7471a18d6214d0ae1df3046414098d527cafd1fa1347809d4"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="7411ba4cc094f807cedab88c2f7a27c13487c9a030ac4596731fd2c615f16a4c"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="da759d6cac131e90128082f06e50f930eb9fcc35e6bd30fef2eac49e6db6c606"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="f863619e920faa3210f23dc5ca2a427038a050bcf447b1fe590522ddb279e1c4"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
