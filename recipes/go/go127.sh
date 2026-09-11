rname="go127"
rver="1.27.1"
rdate="20260911"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="f15f6f58c3af5315edc17524cf4f63486f4797696eed65c7ea9d7445bc7f3fe7"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="a0031a522abfeb1db8be52ac053d018dc7d91cf4b6b1619d9078f79b282b9411"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="0a8f53653bb0c8e776cc0f46432f14f57820a0439d83d36014886b8303081bff"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="03915fd45c1b07cf4b7f00e00c19fcb398940ff6e37895d57c65483ca6c085e0"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="a23e6ff3b7b170f7f5fef948615dfb01f3dee899a9ac8967a443101821c4ddbd"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"

# vim: set ft=bash:
