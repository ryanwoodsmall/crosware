rname="go120"
rver="1.20.1"
rdate="20230214"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="d43ce6b79c1b0cdd53d6d26585c68762a6307446a316e4b45ba8d70985f2144e"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="f65c605c2ce3f82c8a58ea3f4e999fa4dc0a7958eb5d9ea9d524fc7341a1c60b"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="go${rver}-arm64"
  rsha256="a192794e36438f746f17f6b8d51b049ee7fcbb03eb68500dc49cd56331b3bd0e"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="go${rver}-arm"
  rsha256="cb6a7f7a80bc4bfe1f841c261389b95c631bc2b56c6ba5df0f8fd0c6fcc797a1"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="go${rver}-riscv64"
  rsha256="c62913def0ea0535b5b048af7503c2a19ed00a55c72edfed9c77373f2c002230"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go${rver}/${rfile}"

. "${cwrecipe}/go/go.sh.common"
