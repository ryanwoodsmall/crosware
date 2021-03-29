#
# XXX - specifically build shared for jvm, etc., interop
# XXX - MUST opt-in to libz, old zlib still preferred/default
#

rname="libz"
rver="1.2.8.2015.12.26"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sortix.org/${rname}/release/${rfile}"
rsha256="abcc2831b7a0e891d0875fa852e9b9510b420d843d3d20aad010f65493fe4f7b"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
     --enable-shared \
     --enable-static \
       CFLAGS=-fPIC \
       CXXFLAGS=-fPIC \
       CPPFLAGS= \
       LDFLAGS= \
       PKG_CONFIG_LIBDIR= \
       PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"
