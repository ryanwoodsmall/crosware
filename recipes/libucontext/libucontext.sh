rname="libucontext"
rver="1.3.3"
rdir="${rname}-${rver}"
# weird libucontext-libucontext-#.# dir
rbdir="${cwbuild}/${rname}-${rdir}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kaniini/libucontext/archive/refs/tags/${rfile}"
rsha256="06fca63bc00a236ea7e2ce4fe984d7203b1f9ea046f5c8c815d280da4ea281e3"
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
