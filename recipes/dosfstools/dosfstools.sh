rname="dosfstools"
rver="4.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/dosfstools/dosfstools/releases/download/v${rver}/${rfile}"
rsha256="64926eebf90092dca21b14259a5301b7b98e7b1943e8a201c7d726084809b527"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  (
    export LDFLAGS=-static
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    make -j${cwmakejobs} ${rlibtool}
  )
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
