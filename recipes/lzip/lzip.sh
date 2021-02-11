rname="lzip"
rver="1.22"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="c3342d42e67139c165b8b128d033b5c96893a13ac5f25933190315214e87a948"
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
