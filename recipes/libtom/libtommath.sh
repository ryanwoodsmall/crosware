rname="libtommath"
rver="1.3.0"
rdir="${rname}-${rver}"
rfile="ltm-${rver}.tar.xz"
rurl="https://github.com/libtom/${rname}/releases/download/v${rver}/${rfile}"
rsha256="296272d93435991308eb73607600c034b558807a07e829e751142e65ccfa9d08"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} -f makefile.unix PREFIX=\"\$(cwidir_${rname})\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -f makefile.unix PREFIX=\"\$(cwidir_${rname})\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" install
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \"\$(cwidir_${rname})/lib/pkgconfig/${rname}.pc\"
  popd &>/dev/null
}
"
