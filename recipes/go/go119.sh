rname="go119"
rver="1.19.5"
rdate="20230112"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="c25acace75da53ba6fc688bcf172d8039b0367f05283a316a707c2fcca6322e1"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="9683f11af7c0ae5ea500724fda6f9ea1a43ebc97feddbef3b4fd59189426e6f2"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="d77b99a777a02dda80a55146e6a219c2f2747a256a82085ba68776f0b57ba740"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="01109e07140ffcf9c0d11cd4458c4f4c67d6c55b2465298497ae0cd30275e872"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="0641dd9cdb900d6cd8223c6f06768ff310b9dea658f10f41aa72877cc368d18c"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
