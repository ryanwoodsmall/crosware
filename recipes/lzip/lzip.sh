rname="lzip"
rver="1.21"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="e48b5039d3164d670791f9c5dbaa832bf2df080cb1fbb4f33aa7b3300b670d8b"
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
