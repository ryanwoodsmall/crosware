
rname="go120"
rver="1.20.5"
rdate="20230607"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="3c87fe1ba42c61e6adc6ca970f341f1821363932228aec3676a02a6c2caafa2c"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="edbd192ee8b6c5ea6e76023c549fcb188a68b3bd7be26cf49bb0476db81be65b"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="88d1a2f259074e149c8a8cab1d3dcf0fadb01962690027dfedfbc063eec3c19a"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="4168b887ae60457bf314d7abbf71e82a6ed35dab8a4958e0df6865fc077c5831"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="a5c6a468c7611b5ac3d4a5563b8e1fb5020a3e448daf5e24420de399eada990e"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
