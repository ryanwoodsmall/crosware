#
# XXX - aarch32 flakiness w/o -static
# XXX - CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES - Modules/Platform/UnixPaths.cmake
# XXX - CMAKE_INSTALL_LIBDIR - https://cmake.org/cmake/help/v3.0/module/GNUInstallDirs.html
#
# XXX - openssl ugh
# -- Could NOT find OpenSSL, try to set the path to OpenSSL root folder in the system variable OPENSSL_ROOT_DIR (missing: OPENSSL_CRYPTO_LIBRARY OPENSSL_INCLUDE_DIR)
# CMake Error at Utilities/cmcurl/CMakeLists.txt:454 (message):
#  Could not find OpenSSL.  Install an OpenSSL development package or
#  configure CMake with -DCMAKE_USE_OPENSSL=OFF to build without OpenSSL.
#
# XXX - build with libressl+a tiny-curl? probably need a picocurllibressl w/zlib and nothing else... doesn't solve openssl req
# XXX - need to figure out libs too, looks like /lib64 is default in some places (see libgit2)
# XXX - defaults to -O3, tweak down/add -Wl,-s -g0 for no debug to speed up compilation?
#

rname="cmake"
rver="3.29.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Kitware/CMake/releases/download/v${rver}/${rfile}"
rsha256="36db4b6926aab741ba6e4b2ea2d99c9193222132308b4dc824d4123cb730352e"
rreqs="make bash busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  find . -type f -name '*.cmake' -print0 | xargs -0 sed -i.ORIG 's#/usr/include#/no/usr/include#g;s#/usr/lib#/no/usr/lib#g'
  sed -i.ORIG 's#-DCMAKE_BOOTSTRAP=1#-DCMAKE_BOOTSTRAP=1 -DCMAKE_IGNORE_PATH=/usr/include -DCMAKE_USE_OPENSSL=OFF#g' bootstrap
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  find \"\$(cwidir_${rname})/bin/\" -type f | xargs file | grep 'ELF.*not stripped' | cut -f1 -d: | xargs strip --strip-all || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
