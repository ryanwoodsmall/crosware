#
# XXX - needs gnu (or invisible island!) indent for (system-provided) gperf support
#
rname="libcap"
rver="2.71"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${rfile}"
rsha256="c2dff7c9f43644172a5ef6b0180781137f77ee9fe45a08eebaf0e8335228b0de"
rreqs="make attr"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make lib=lib prefix=\"\$(cwidir_${rname})\" GOLANG=no USE_GPERF=no
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cd libcap
  make install-static lib=lib prefix=\"\$(cwidir_${rname})\" GOLANG=no USE_GPERF=no
  cd -
  cd progs
  make install lib=lib prefix=\"\$(cwidir_${rname})\" GOLANG=no USE_GPERF=no
  cd -
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
