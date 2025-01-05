rname="go123"
rver="1.23.4"
rdate="20250105"
if [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="e8c3da40b1f5a71c78252805eb72315f09e87ac221ecf7b7b957df3ba736a581"
elif [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="e6572aac9eefe0e32a36cfbbd807d8302527f353b8d095a454d1d5758ca99532"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="127f2a363b400cbd749cb380d6974b644294706211920d34562ed72039cffbb6"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="4161ecbdbb82993b5e47107ac8aa4450d2bb3b0bd89b885438328b4062764197"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="53e8c509fd475857f1163a4b027294dd2fdce71d3611a469689d54f3d508e988"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
