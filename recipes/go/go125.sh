rname="go125"
rver="1.25.2"
rdate="20251007"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="47f6c74cb283390bbdcb25794a63183375470c86d34f16d2afaf6bffc242e1e9"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="0a8c19fb5be25e5638b9564d33d12552e263e1fd84d39baf3eaf4334fbe5bde7"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="c0035f51fbbb77b0828c698f85a4cbcf17d2c1cad69683ae7bd444bfdeb2c63f"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="2e3af7ef4415847d1d606addd2ee4624e88801c688dc1bfd8fca304a60280ea2"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="b308becc6a909bc6a6a51b9c3776388f2916ad89994f378bcf5a52404c2debf1"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
