rname="go125"
rver="1.25.7"
rdate="20260210"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="36a6185328e2978dd3e6059dc85f90f6dff5f2d1b7a50b333abf98516b77107f"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="117dc171040f62fc2f99c6eb989ddac99c5be6f10dc400aaacd521fbc040c874"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="aa7e089b9c46fd431bb5c399091b210ab07257918e9b89b242545f76e6c65728"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="a1940f8608b7af46c890fe4036e485dd30232efcee30c82aa66a91d5754cfcb9"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="c2b10dae9021b021227bc9fa3d69e08a81fa2f5057170819b5fa99a861688352"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
