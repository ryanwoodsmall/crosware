rname="lzip"
rver="1.20"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="c93b81a5a7788ef5812423d311345ba5d3bd4f5ebf1f693911e3a13553c1290c"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CPPFLAGS=\"\${CPPFLAGS}\" CXX=\"\${CXX}\" CXXFLAGS=\"\${CXXFLAGS}\" LDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
