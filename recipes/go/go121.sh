rname="go121"
rver="1.21.6"
rdate="20240116"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="e8e568a1037e713674f3a087400a3b22b0c6208e245ba300f2da3669b96948a7"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="01c37e7b94aa8e05a797feded25e99200cfeec93c5e90293a1bccc53365c74a4"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="5987e74740660469c5059a4f721542f19e9ccfc65f19824694a0789fe9200d85"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="afc54305c4160c731b1de61e8be20d1eec06539c6d94a06735a0d8a8010cf1c7"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="971116b810d4e8b98474c930849294d4904223d9b583f2e6a6d015c56e2c07f2"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
