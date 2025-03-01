#
# XXX - explicitly opt-in
# XXX - 2.1.x broke something with shared, might be gcc version. turn it off for now
#
rname="zlibng"
rver="2.2.4"
rdir="zlib-ng-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${rfile}"
rsha256="a73343c3093e5cdc50d9377997c3815b878fd110bf6511c2c7759f2afb90f5a3"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}_zlibng_static() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env LDFLAGS=-static CPPFLAGS= ./configure ${cwconfigureprefix} --static --without-{optimizations,new-strategies,neon,acle,armv6}
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd &>/dev/null
  cwclean_${rname}
}
"

#eval "
#function cwmakeinstall_${rname}_zlibng_shared() {
#  cwclean_${rname}
#  cwextract_${rname}
#  pushd \"\$(cwbdir_${rname})\" &>/dev/null
#  env CFLAGS=-fPIC LDFLAGS= CPPFLAGS= ./configure --prefix=\"\$(cwidir_${rname})/shared\" --without-{optimizations,new-strategies,neon,acle,armv6}
#  make -j${cwmakejobs} ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS=
#  make install ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS=
#  popd &>/dev/null
#  cwclean_${rname}
#}
#"

eval "
function cwmakeinstall_${rname}_zlib_static() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env LDFLAGS=-static CPPFLAGS= ./configure ${cwconfigureprefix} --static --zlib-compat --without-{optimizations,new-strategies,neon,acle,armv6}
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd &>/dev/null
  cwclean_${rname}
}
"

#eval "
#function cwmakeinstall_${rname}_zlib_shared() {
#  cwclean_${rname}
#  cwextract_${rname}
#  pushd \"\$(cwbdir_${rname})\" &>/dev/null
#  env CFLAGS=-fPIC LDFLAGS= CPPFLAGS= CC=\"\${CC} -I\$(cwidir_${rname})/shared/include -L\$(cwidir_${rname})/shared/lib -lz-ng -Wl,-rpath=${rtdir}/current/shared/lib\" ./configure --prefix=\"\$(cwidir_${rname})/shared\" --zlib-compat --without-{optimizations,new-strategies,neon,acle,armv6}
#  make -j${cwmakejobs} ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS= CC=\"\${CC} -I\$(cwidir_${rname})/shared/include -L\$(cwidir_${rname})/shared/lib -lz-ng -Wl,-rpath=${rtdir}/current/shared/lib\"
#  make install ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS= CC=\"\${CC} -I\$(cwidir_${rname})/shared/include -L\$(cwidir_${rname})/shared/lib -lz-ng -Wl,-rpath=${rtdir}/current/shared/lib\"
#  popd &>/dev/null
#  cwclean_${rname}
#  cwcreatesharedlib \"\$(cwidir_${rname})/lib/libz.a\" \"\$(cwidir_${rname})/shared/lib/libz.so.1.2.11.standalone\"
#  ln -sf libz.so.1.2.11.standalone \"\$(cwidir_${rname})/shared/lib/libz.so.standalone\"
#}
#"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_zlibng_static
  #cwmakeinstall_${rname}_zlibng_shared
  cwmakeinstall_${rname}_zlib_static
  #cwmakeinstall_${rname}_zlib_shared
}
"
