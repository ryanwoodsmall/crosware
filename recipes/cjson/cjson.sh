rname="cjson"
rver="1.7.16"
rdir="${rname//json/JSON}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/DaveGamble/${rname//json/JSON}/archive/refs/tags/${rfile}"
rsha256="451131a92c55efc5457276807fc0c4c2c2707c9ee96ef90c47d68852d5384c6c"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make lib${rname}{,_utils}.a CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/include/${rname}\"
  cwmkdir \"${ridir}/lib\"
  install -m 0644 c*.h \"${ridir}/include/${rname}/\"
  install -m 0644 lib*.a \"${ridir}/lib/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
