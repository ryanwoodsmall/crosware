rname="zlib"
rver="1.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/madler/zlib/releases/download/v${rver}/${rfile}"
rsha256="02dd159783677a749c04adbdd02b55b8a2bcc7e054f51b76b549199a916ad584"
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
