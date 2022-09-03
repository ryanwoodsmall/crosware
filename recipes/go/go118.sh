rname="go118"
rver="1.18.5"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="79ed0771570871c20dcc01e504206a740c01f30b5b43268382bbca9afd0354c5"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="d625e7a9a4a1adc3d5be0fbbc321996fb496979365017661f7c9fa41245ddf13"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="201adae3d1ff8f7c27c30358b50d1c9c8cce7e416c9c5cbcb6644a65d0b846d8"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="feef67c76b1049bad1d3138137dbb84ee33aeab10e01c9012b6d6c7687575cda"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="bc45b94e5ead143858ffdc834a5fafb5f24c5cca0e456ae210c26e2ed6c0410b"
fi
rdate="20220902"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.19/${rfile}"

. "${cwrecipe}/go/go.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/go/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
