rname="go126"
rver="1.26.4"
rdate="20260608"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="c1b9823f5d97166a6ab8f6323e395c2cb143e00c5105ff0cdda49a2e4e8d82bf"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="47556653f39eefea52e8a620f6a2585526e5d367616b052541fc8264982ce7d8"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="6bfe56f5d3d1c83d787cf6ce4caedfebc703dae1d0c390d68f453e201673f2a6"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="dddc2c103739439ca49d9e9ead934fba953d04ee58e745c8d1ce722837a762be"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="27087203194577778d51f3e8c3af6421764f9dccf945dfa6bf6ccb0f8b3d3cad"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
