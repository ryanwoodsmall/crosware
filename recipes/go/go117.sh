rname="go117"
rver="1.17.10"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="18325c11cb9ed74e21cd5f408afc0347441a7e7e3aed81007422c2ae9a27db37"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="3f012472ab732ffd355d200671aeffba80524c61d5176638392cf66ecc703ff0"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="be41b9d13ad4742da3259951cfed8a5a1ac78a4b1514ed17864dae883449d1d9"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="43aaee1fb0e925d520148fce1de7395b0474116235f37cb4b41b6a22aa3dc30d"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="4dccbe0b7de386699e860eefffcc44e4939fac7435d00076990f418490a4ee07"
fi
rdate="20220511"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.18.2/${rfile}"

. "${cwrecipe}/go/go.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/go/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
