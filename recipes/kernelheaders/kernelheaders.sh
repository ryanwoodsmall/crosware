#
# XXX - no risc-v 64-bit (riscv64) support yet...
#

rname="kernelheaders"
rver="4.19.88"
rdir="kernel-headers-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/kernel-headers/archive/${rfile}"
rsha256="d104397fc657ffb0f0bda46f54fd182b76a9ebc324149c183a4ff8c86a8db53d"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local a
  if [[ ${karch} =~ ^aarch64 ]] ; then
    a=aarch64
  elif [[ ${karch} =~ ^arm ]] ; then
    a=arm
  elif [[ ${karch} =~ ^i.86 ]] ; then
    a=x86
  elif [[ ${karch} =~ ^x86_64 ]] ; then
    a=x86_64
  else
    cwfailexit \"how did you get here\"
  fi
  make ARCH=\${a} prefix=\"${ridir}\" install
  unset a
  popd >/dev/null 2>&1
}
"
