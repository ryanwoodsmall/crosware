rname="go119"
rver="1.19"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="975c9065942365029eed461f57fcea519d1929f6d032b0d46ecb54098adebe50"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="f4c54d9df2657dd3f80e9d750f5c69d753c6b84593a749b66d60165582b5c642"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="c421cd247885cb661766c8d41c9f6e29d50f115aa44c100e39b9656a30dc28bf"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="b421c834d25472426f533149fa6f7b9c2e039cc632b9166b5fb5a20bb81d9c58"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="df65b2defdc1a93813d14faa789015d42e156a61de66e3765f12ca9e8ca64b07"
fi
rdate="20220902"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.19/${rfile}"

. "${cwrecipe}/go/go.sh.common"
