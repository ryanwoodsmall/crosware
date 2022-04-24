#
# XXX - explicitly opt-in
# XXX - explicitly builds a shared libz library from libz.a static (musl-based jdks, etc.)
# XXX - this should work...
#

rname="zlibng"
rver="2.0.6"
rdir="zlib-ng-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${rfile}"
rsha256="8258b75a72303b661a238047cb348203d88d9dddf85d480ed885f375916fcab6"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwmakeinstall_${rname}_zlibng_static() {
  cwclean_${rname}
  cwextract_${rname}
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CFLAGS=-fPIC LDFLAGS= CPPFLAGS= ./configure --prefix=\"${ridir}/shared\"
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  env LDFLAGS=-static CPPFLAGS= ./configure ${cwconfigureprefix} --static --zlib-compat
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd >/dev/null 2>&1
  cwclean_${rname}
}
"

eval "
function cwmakeinstall_${rname}_zlib_shared() {
  cwcreatesharedlib \"${ridir}/lib/libz.a\" \"${ridir}/shared/lib/libz.so.1\"
  ln -sf libz.so.1 \"${ridir}/shared/lib/libz.so\"
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
