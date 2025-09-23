rname="go125"
rver="1.25.1"
rdate="20250922"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="cb50d49245b785e83a6cd1e3c330250914b93d0c70cbb6b49b4fe2b03f7a3651"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="33c6a4ac664873510f9e4292602b9cbf02db5f5a7b0f6e9f9dc58a1d0d46b406"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="60efc1b49489146c7dead049ef8a60434369f18206aa123b93770a429d77c574"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="9b64bf41d026ba103eab605b2a3a7eea54bbba1e9c900a966c46511eeff8e302"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="9c35bdd3423f9b0262812a459d522593daffb81328400c8111d014f983703d15"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
