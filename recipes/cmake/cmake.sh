#
# XXX - aarch32 flakiness w/o -static
# XXX - CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES - Modules/Platform/UnixPaths.cmake
#

rname="cmake"
rver="3.15.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Kitware/CMake/releases/download/v${rver}/${rfile}"
rsha256="18dec548d8f8b04d53c60f9cedcebaa6762f8425339d1e2c889c383d3ccdd7f7"
rreqs="make bash busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  find . -type f -name '*.cmake' -print0 | xargs -0 sed -i.ORIG 's#/usr/include#/no/usr/include#g;s#/usr/lib#/no/usr/lib#g'
  sed -i.ORIG 's#-DCMAKE_BOOTSTRAP=1#-DCMAKE_BOOTSTRAP=1 -DCMAKE_IGNORE_PATH=/usr/include#g' bootstrap
  sed -i.ORIG 's#\"/lib#\"/no/lib#g;s#\"/usr/lib#\"/no/usr/lib#g' Source/cmExportInstallFileGenerator.cxx CMakeLists.txt
  sed -i.ORIG '/CMAKE_FIND_LIBRARY_SUFFIXES/s/\"\\.so\" \"\\.a\"/\".a\" \".so\"/g' Modules/CMakeGenericSystem.cmake
  sed -i.ORIG 's# /lib# /no/lib#g' Modules/Platform/UnixPaths.cmake
  sed -i '/\\/usr\\/local/s# /# /no/#g' Modules/Platform/UnixPaths.cmake
  env CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH= \
      PATH=\"${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/bash/current/bin:${cwsw}/busybox/current/bin:${cwsw}/toybox/current/bin:${cwsw}/make/current/bin\" \
      ./bootstrap \
        ${cwconfigureprefix} \
        --no-system-libs \
        --parallel=${cwmakejobs} \
        --verbose \
          CFLAGS=\"\${CFLAGS} -static\" \
          CXXFLAGS=\"\${CXXFLAGS} -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  #find \"${ridir}\" -type f -name CMakeGenericSystem.cmake | xargs sed -i.SO 's/\"\\.so\" \"\\.a\"/\".a\" \".so\"/g'
  find \"${ridir}/bin/\" -type f | xargs file | grep 'ELF.*not stripped' | cut -f1 -d: | xargs strip --strip-all
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
