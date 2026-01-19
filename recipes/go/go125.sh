rname="go125"
rver="1.25.6"
rdate="20260119"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="506fb0a34f733f4c02c74e27e0d2fd9bbd198156be0472f9c01a88c0e5ad89a1"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="93e625dc83bee5eacb9f87e256866b6c8317683d0f36c074766c8c13735b592d"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="1675505fbae474b44689b96ad8d7057609a044a6d7bedf10a26672a12fc2f611"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="930798eb7a0d7ba1064e3e2d2c0a0ddbf3042e162380d0931703bfa9fea3082e"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="e473e9cb36cd1944b31cb6057a2881c3cf648e6697c126189a0138fdff885e40"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
