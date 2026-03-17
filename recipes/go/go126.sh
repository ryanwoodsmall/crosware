rname="go126"
rver="1.26.1"
rdate="20260317"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="4f92edb1ed4135aa0e5a6531dac9b94e7cd1a24cb6ed7ac22a5e3c2bf60b4d93"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="939de33366fc6d8660c28d00442e2ffd754f6c65fb7520eff2f58d3f8b1afd83"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="0d3a360bbfba2e1d64ebb38b9796c46fc0728d7007cf81a24635df164835238e"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="7676ee1c3b07c5a53f55d4815116918c17ca1832df8072a9c006e4a01aaa1681"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="db743d6c97a0da73277c9e3957c69dd1be52e16d582167a744afd43160565cb6"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
