rname="zlib"
rver="1.2.13"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://zlib.net/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
#rurl="https://downloads.sourceforge.net/project/libpng/${rname}/${rver}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30"
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make clean || true
  env CFLAGS=\"\${CFLAGS} -fPIC\" ./configure ${cwconfigureprefix} --static
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_shared() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make clean || true
  env CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS= ./configure --prefix=\"\$(cwidir_${rname})/shared\" --shared
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
