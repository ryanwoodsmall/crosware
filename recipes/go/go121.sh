rname="go121"
rver="1.21.1"
rdate="20230908"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="8b42ebbbf75f9aa582b61fa1d61623c7e39b4f1545000af1a4eeb19ce44c3b1e"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="51c529cf210a9410a8d7282748ff8e1a22b5d67395c0dd25d8d06ce489115562"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="6b84a98ae2a3899c5f8e634be818eec59f03e4a5499b05e6b5866d2bf7e43a74"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="4785ef3bcafea6f91df564d4b597c0f3036fd32dc6953336d537cdda686d2fc1"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="2e3a122b36e513e5c5c2f17b222631a615b1c30dda6fa7c5b0d09cd4c39de209"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
