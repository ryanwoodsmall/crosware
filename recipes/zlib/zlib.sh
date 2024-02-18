rname="zlib"
rver="1.3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/madler/zlib/releases/download/v${rver}/${rfile}"
rsha256="9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
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
  env CFLAGS=\"\${CFLAGS} -fPIC\" ./configure ${cwconfigureprefix} --static
  make -j${cwmakejobs} ${rlibtool}
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
