#
# XXX - no risc-v 64-bit (riscv64) support yet...
# XXX - move to alpine-ish setup? https://git.alpinelinux.org/aports/tree/main/linux-headers?h=master
#

rname="kernelheaders"
rver="4.19.88-2"
rdir="linux-headers-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/sabotage-linux/kernel-headers/releases/download/v${rver}/${rfile}"
rsha256="dc7abf734487553644258a3822cfd429d74656749e309f2b25f09f4282e05588" 
rreqs="make"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local a
  if [[ \${karch} =~ ^aarch64 ]] ; then
    a=aarch64
  elif [[ \${karch} =~ ^arm ]] ; then
    a=arm
  elif [[ \${karch} =~ ^i.86 ]] ; then
    a=x86
  elif [[ \${karch} =~ ^x86_64 ]] ; then
    a=x86_64
  elif [[ \${karch} =~ ^riscv ]] ; then
    a=riscv
  else
    cwfailexit \"how did you get here\"
  fi
  make ARCH=\${a} prefix=\"\$(cwidir_${rname})\" install
  unset a
  popd >/dev/null 2>&1
}
"
