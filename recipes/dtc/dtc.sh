rname="dtc"
rver="1.7.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/${rfile}"
rsha256="8f1486962f093f28a2f79f01c1fd82f144ef640ceabe555536d43362212ceb7c"
rreqs="make bison flex pkgconf"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export LDFLAGS=-static
    make all STATIC_BUILD=1 NO_PYTHON=1 PREFIX=\"\$(cwidir_${rname})\"
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export LDFLAGS=-static
    make install STATIC_BUILD=1 NO_PYTHON=1 PREFIX=\"\$(cwidir_${rname})\"
    rm -rf \$(cwidir_${rname})/lib/shared
    cwmkdir \$(cwidir_${rname})/lib/shared
    mv \$(cwidir_${rname})/lib/*.so* \$(cwidir_${rname})/lib/shared/ || true
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
