rname="go125"
rver="1.25.3"
rdate="20251018"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="2f1d60ee6f60a380330d4d308f912583f3703fe0b8ce0fdb010efaf5e9bd9752"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="c12f833b7c6fb55381bd7322999d2a22f31f3643de035f862874763c92e3f339"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="8eff6819d2eff587cf2cc62bdaac0099c52f3c3c5cec03d95b96d70d0bdd760e"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="bc5b5f853dc0eadd396e48d90fac1289253259340b462cbf41418128f48d95b9"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="704396e3a9b8eef8acfd05472673bcb5bb86237d04200c6d9d553f103f4b3a74"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
