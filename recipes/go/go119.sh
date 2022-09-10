rname="go119"
rver="1.19.1"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="f69b563d558f7899895668bc001c327dbfc14c8f0cf49d67012343f42e8dfd1a"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="6df4517162a00fc65f9685a7dcc3f336ab1cdc86997c0b52b0d8b460fde6a615"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="3bf29389aac84cdf685ec9d0ba03f5fd50d94cc31d314685600b8e809888f7d1"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="4bee8a3d8c703426d8fd0314364b53458dbc15e1174cbbd64099eafd5a6eb6ce"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="630fd517d0c073f2644001b627938d151b64e30d3ea8df1f9388e0876671f669"
fi
rdate="20220910"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.19.1/${rfile}"

. "${cwrecipe}/go/go.sh.common"
