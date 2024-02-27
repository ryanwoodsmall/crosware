rname="microsocks"
rver="1.0.4"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/rofl0r/${rname}/archive/refs/tags/${rfile}"
rsha256="130127a87f55870f18fbe47a64d9b9533020e2900802d36a0f6fd2b074313deb"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"s,^prefix.*,prefix=\$(cwidir_${rname}),g\" Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make CC=\"\${CC}\" CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
