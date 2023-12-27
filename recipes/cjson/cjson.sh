rname="cjson"
rver="1.7.17"
rdir="${rname//json/JSON}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/DaveGamble/${rname//json/JSON}/archive/refs/tags/${rfile}"
rsha256="c91d1eeb7175c50d49f6ba2a25e69b46bd05cffb798382c19bfb202e467ec51c"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make lib${rname}{,_utils}.a CC=\"\${CC}\" CXX=\"\${CXX}\" CFLAGS=-fPIC CXXFLAGS=-fPIC AR=\"\${AR}\" LD=\"\${LD}\" LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/include/${rname}\"
  cwmkdir \"\$(cwidir_${rname})/lib\"
  install -m 0644 c*.h \"\$(cwidir_${rname})/include/${rname}/\"
  install -m 0644 lib*.a \"\$(cwidir_${rname})/lib/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
