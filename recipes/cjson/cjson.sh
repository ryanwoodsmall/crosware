rname="cjson"
rver="1.7.19"
rdir="${rname//json/JSON}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/DaveGamble/${rname//json/JSON}/archive/refs/tags/${rfile}"
rsha256="7fa616e3046edfa7a28a32d5f9eacfd23f92900fe1f8ccd988c1662f30454562"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make lib${rname}{,_utils}.a CC=\"\${CC}\" CXX=\"\${CXX}\" CFLAGS=-fPIC CXXFLAGS=-fPIC AR=\"\${AR}\" LD=\"\${LD}\" LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/include/${rname}\"
  cwmkdir \"\$(cwidir_${rname})/lib\"
  install -m 0644 c*.h \"\$(cwidir_${rname})/include/${rname}/\"
  install -m 0644 lib*.a \"\$(cwidir_${rname})/lib/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
