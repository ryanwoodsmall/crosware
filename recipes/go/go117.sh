rname="go117"
rver="1.17.13"
rdate="20220902"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="b6593b673a2988e50211322ea0ebf9ed0c210f90ce51ea14fc69cb95f7766fc5"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="dff190615646d4e48269bc40d6c54a3c1127182fc73e8cb47c4ff271324e15a6"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="19cdb0a2288d0d6624d5e4c551d595f2dff564c783cb0b3e85ab9a1751da99ac"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="fabad595a46edc97c3348a583be85215c84a08d9f44c59f225038616ae8fd16f"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="cd9731c57cc483a878fbe9dfc50339f9d423fa112d5b3e5724e32038edb7e2ba"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.19/${rfile}"

. "${cwrecipe}/go/go.sh.common"
