rname="cjson"
rver="1.7.14"
rdir="${rname//json/JSON}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/DaveGamble/${rname//json/JSON}/archive/refs/tags/${rfile}"
rsha256="fb50a663eefdc76bafa80c82bc045af13b1363e8f45cec8b442007aef6a41343"
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
