#
# XXX - needs gnu (or invisible island!) indent for (system-provided) gperf support
#
rname="libcap"
rver="2.73"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${rfile}"
rsha256="16d8e4e625d2a2ed1601172704c560de3745bac64ab1384a8074379c03165948"
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
