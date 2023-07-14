rname="go120"
rver="1.20.6"
rdate="20230713"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="ac50f255f441211287413a6d2172b51daf436b3da80d17e1f0465265634930a3"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="2b19a5e386b430b8533aa615313d706e088868aa2463afa5a745809bac49db20"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="e4b499de45b5f1734ac96b2fee145026849a252d66651a220ed6569a789ac0cc"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="b02e4f336ee66c45085954ab56a1bb8b36760fb9a1db89491a86c75c422f7680"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="1b9b6f54f9c7c8f00282e74a89e8c9f05ec10a2803de9c36395db4528bcd539f"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
