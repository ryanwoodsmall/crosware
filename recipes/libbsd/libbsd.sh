#
# XXX - need to fixup .pc with -L${cwsw}/libmd/current/lib as well?
#
rname="libbsd"
rver="0.11.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="55fdfa2696fb4d55a592fa9ad14a9df897c7b0008ddb3b30c419914841f85f33"
rreqs="bootstrapmake libmd"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS='-L${cwsw}/libmd/current/lib -static' CPPFLAGS='-I${cwsw}/libmd/current/include' PKG_CONFIG_{LIBDIR,PATH}=
  echo '#include <fcntl.h>' >> config.h
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  rm -f \$(cwidir_${rname})/lib/*.so
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
