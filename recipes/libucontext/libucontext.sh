rname="libucontext"
rver="1.5.1"
rdir="${rname}-${rver}"
# weird libucontext-libucontext-#.# dir
rbdir="${cwbuild}/${rname}-${rdir}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kaniini/libucontext/archive/refs/tags/${rfile}"
rsha256="228925a4427339283b79b5ba1357ec11a7dea32ec46bd191a88c0542eb13e679"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"s,^prefix.*=.*/usr,prefix=\$(cwidir_${rname}),g\" Makefile
  popd &>/dev/null
}
"
eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static make LIBDIR=\"\$(cwidir_${rname})/lib\" INCLUDEDIR=\"\$(cwidir_${rname})/include\" PKGCONFIGDIR=\"\$(cwidir_${rname})/lib/pkgconfig\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static make install LIBDIR=\"\$(cwidir_${rname})/lib\" INCLUDEDIR=\"\$(cwidir_${rname})/include\" PKGCONFIGDIR=\"\$(cwidir_${rname})/lib/pkgconfig\"
  rm -f \$(cwidir_${rname})/lib/*.so* || true
  popd &>/dev/null
}
"
