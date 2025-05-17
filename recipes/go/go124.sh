rname="go124"
rver="1.24.3"
rdate="20250516"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="2b8aa66b9d7ddfb16e0e90b84ebcb2c58e72ae1bd78dbaffb5389ef598431d73"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="233ad3a0eebd72c249d1a21ccd7d3e1781d906065b0c6439b935748c4210373a"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="9199b78fe5294a8de54b11890dc304b00e92a6b694d8add99e948a03e5f6f34e"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="306887935baecaa9859eac9e53cba081a11201e6209bf7d67feb86a3c24ee6ba"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="0a85576d210d319128700fa44a03aedc2d0d8970af92284d76c03cdfcd083bf8"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
