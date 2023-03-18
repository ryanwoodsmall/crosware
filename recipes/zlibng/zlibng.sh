#
# XXX - explicitly opt-in
#

rname="zlibng"
rver="2.0.7"
rdir="zlib-ng-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${rfile}"
rsha256="6c0853bb27738b811f2b4d4af095323c3d5ce36ceed6b50e5f773204fb8f7200"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}_zlibng_static() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env LDFLAGS=-static CPPFLAGS= ./configure ${cwconfigureprefix} --static
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd >/dev/null 2>&1
  cwclean_${rname}
}
"

eval "
function cwmakeinstall_${rname}_zlibng_shared() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CFLAGS=-fPIC LDFLAGS= CPPFLAGS= ./configure --prefix=\"\$(cwidir_${rname})/shared\"
  make -j${cwmakejobs} ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS=
  make install ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS=
  popd >/dev/null 2>&1
  cwclean_${rname}
}
"

eval "
function cwmakeinstall_${rname}_zlib_static() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env LDFLAGS=-static CPPFLAGS= ./configure ${cwconfigureprefix} --static --zlib-compat
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd >/dev/null 2>&1
  cwclean_${rname}
}
"

eval "
function cwmakeinstall_${rname}_zlib_shared() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CFLAGS=-fPIC LDFLAGS= CPPFLAGS= CC=\"\${CC} -I\$(cwidir_${rname})/shared/include -L\$(cwidir_${rname})/shared/lib -lz-ng -Wl,-rpath=${rtdir}/current/shared/lib\" ./configure --prefix=\"\$(cwidir_${rname})/shared\" --zlib-compat
  make -j${cwmakejobs} ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS= CC=\"\${CC} -I\$(cwidir_${rname})/shared/include -L\$(cwidir_${rname})/shared/lib -lz-ng -Wl,-rpath=${rtdir}/current/shared/lib\"
  make install ${rlibtool} CFLAGS=-fPIC LDFLAGS= CPPFLAGS= CC=\"\${CC} -I\$(cwidir_${rname})/shared/include -L\$(cwidir_${rname})/shared/lib -lz-ng -Wl,-rpath=${rtdir}/current/shared/lib\"
  popd >/dev/null 2>&1
  cwclean_${rname}
  cwcreatesharedlib \"\$(cwidir_${rname})/lib/libz.a\" \"\$(cwidir_${rname})/shared/lib/libz.so.1.2.11.standalone\"
  ln -sf libz.so.1.2.11.standalone \"\$(cwidir_${rname})/shared/lib/libz.so.standalone\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_zlibng_static
  cwmakeinstall_${rname}_zlibng_shared
  cwmakeinstall_${rname}_zlib_static
  cwmakeinstall_${rname}_zlib_shared
}
"
