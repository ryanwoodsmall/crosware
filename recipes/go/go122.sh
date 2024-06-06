rname="go122"
rver="1.22.4"
rdate="20240606"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="0bc65343caae68d617ea2e004395a1be6ef454956592a8550c20f23e691a9bf3"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="fe010e6280ccf17da392ec9af894e29d75786f959c0bd7891525eb5fc9eaf5c1"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="327f82320d9f1776e783ee822590d08c0a47d504e19953f732249f6c4c846c75"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="aaf7328b1607cd6254cd31cacc4117039802a68d2734fd68578a0a837f4a1bc8"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="ae02808932b15441355de54ef95c2c6608afb1b3160b77e1c382cb4b3ebb67fd"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
