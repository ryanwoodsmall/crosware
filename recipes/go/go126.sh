rname="go126"
rver="1.26.2"
rdate="20260417"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="013feb4844c26b2327384f27bb2407742a1c11eecc337eee1e1eadb82d40e43f"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="656e546e401f793ca5ccbf0d646cc95daa5abb8602616147de50e4422be345e4"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="659582931c988d729fb14680fe02117ee5787f4dfeedd7b18c16706dfc3284d1"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="66f7bc80095889e6e55aab04749619e859ac4b92f8920dc174a384fc7dcde5c3"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="efa1947f369e371bddb744511e9fa29e3244332f3a67c0bbefbff84c2e2a3e1a"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
