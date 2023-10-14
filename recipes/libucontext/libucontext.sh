rname="libucontext"
rver="1.2"
rdir="${rname}-${rver}"
# weird libucontext-libucontext-#.# dir
rbdir="${cwbuild}/${rname}-${rdir}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kaniini/${rname}/archive/refs/tags/${rfile}"
rsha256="937fba9d0beebd7cf957b79979b19fe3a29bb9c4bfd25e869477d7154bbf8fd3"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static make LIBDIR=\"\$(cwidir_${rname})/lib\" INCLUDEDIR=\"\$(cwidir_${rname})/include\" PKGCONFIGDIR=\"\$(cwidir_${rname})/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static make install LIBDIR=\"\$(cwidir_${rname})/lib\" INCLUDEDIR=\"\$(cwidir_${rname})/include\" PKGCONFIGDIR=\"\$(cwidir_${rname})/lib/pkgconfig\"
  rm -f \$(cwidir_${rname})/lib/*.so* || true
  popd >/dev/null 2>&1
}
"
