rname="zlib"
rver="1.3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/madler/zlib/releases/download/v${rver}/${rfile}"
rsha256="bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_static
  cwmakeinstall_${rname}_shared
}
"

eval "
function cwmakeinstall_${rname}_static() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make clean || true
  env CFLAGS=\"\${CFLAGS} -fPIC\" CPPFLAGS= LFLAGS=-static ./configure ${cwconfigureprefix} --static
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  make install ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}_shared() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make clean || true
  env CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS= ./configure --prefix=\"\$(cwidir_${rname})/shared\" --shared
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
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
