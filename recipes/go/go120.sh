rname="go120"
rver="1.20.4"
rdate="20230503"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="e1f12e25aaf10217f8b419db984f9212d12f552b6e026ee1d7b2ab3c9c74e862"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="f441007619c5a7943c1a39c86ecd47dcabad2bcb8952fbe3017d4c4b408956c6"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="d9bd8d39bee821eb8d7240c9421152259ebeb911337a887139bc3aa920b021d7"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="816ddc22316a46b8a6bcd364dcedb1fa3b897658ea0e0d6f6b9128d89720e8de"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="9ff976c53b6e63a0cf0677915d5afba0a5474300b2c431bc8f0dca7a71dc02c3"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
