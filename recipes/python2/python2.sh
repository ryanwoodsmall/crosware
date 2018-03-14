rname="python2"
rver="2.7.14"
rdir="Python-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.python.org/ftp/python/${rver}/${rfile}"
rsha256="71ffb26e09e78650e424929b2b457b9c912ac216576e6bd9e7d204ed03296a66"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  #./configure ${cwconfigureprefix} LDFLAGS=\"\${LDFLAGS//-static/}\" CFLAGS=\"\${CFLAGS//-Wl,-static/}\" CXXFLAGS=\"\${CXXFLAGS//-Wl,-static/}\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS='' CFLAGS='' CXXFLAGS='' CPPFLAGS=''
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
