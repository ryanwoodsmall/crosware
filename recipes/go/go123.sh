rname="go123"
rver="1.23.6"
rdate="20250228"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="7a51253f10bf3ac189aaf61cea1159b343b40ac28c9877868c947dfecc53c67c"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="0e1524bfe00ca5ed059b7a9718e6fb8ee9970aed6666c66337d107d2d458b1f6"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="6e3c38beede1ecb03e31eeb3d60547ea9e8765a80d13d4234f3808e21c24adce"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="3e9a3b39915e4c2e4b4df01a4fbd1217629b6fc61ecdb5e7d951db6491c5a398"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="f7f783ad7fb5a0ed83e7a7144d168009e03757097cbec89c31a945d048987bc8"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
