rname="sslh"
rver="1.21c"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/yrutschle/${rname}/archive/refs/tags/${rfile}"
rsha256="2e457e59592f8e523cade8d9302b0fdc87f8ea0322beb674dd7f067547a93ea9"
rreqs="make pcre libconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/^PREFIX/s,PREFIX.*,PREFIX=${ridir},g' Makefile
  sed -i 's/-lpcreposix/-lpcreposix -lpcre/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{pcre,libconfig}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{pcre,libconfig}/current/lib) -static\" \
    PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{pcre,libconfig}/current/include | tr ' ' ':')\" \
    PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{pcre,libconfig}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
