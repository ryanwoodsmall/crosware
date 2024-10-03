rname="go123"
rver="1.23.2"
rdate="20241002"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="e0e1e1bab82bd8ac6f499e8cb875ae87941a912e9628ad8549b9fb933c9e75f5"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="8d626ef81e9a856d204a37cb1c935222a0c1a16124aa24865c33064ffb75eb33"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="f7f8ca869dec8b4ea308b44d6492d0ea7e1953736f53f272f2e21b24296e5696"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="813aa35ce33043d15956f772522c0b7ede7381b2bd94f8cb67c1f889d73cf489"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="683fa2f3ff62af946e3edd0d240c3223c8217e67f310717c4127d6beaf27d81c"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
