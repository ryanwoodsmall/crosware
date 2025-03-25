#
# XXX - needs gnu (or invisible island!) indent for (system-provided) gperf support
#
rname="libcap"
rver="2.75"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${rfile}"
rsha256="f58898263cf4a20da5920e4340b3ff7addfa5021b48d79e7ad6b97c196557998"
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
