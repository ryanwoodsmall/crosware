rname="microsocks"
rver="1.0.5"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/rofl0r/${rname}/archive/refs/tags/${rfile}"
rsha256="939d1851a18a4c03f3cc5c92ff7a50eaf045da7814764b4cb9e26921db15abc8"
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
