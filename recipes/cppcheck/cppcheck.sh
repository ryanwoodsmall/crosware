rname="cppcheck"
rver="1.89"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/danmar/${rname}/archive/${rfile}"
rsha256="37452d378825c7bd78116b4d7073df795fa732207d371ad5348287f811755783"
rreqs="make pcre"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  cwscriptecho \"${rname} configure noop\"
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/pcre/current/bin:\${PATH}\" make -j${cwmakejobs} \
    PREFIX=\"${ridir}\" \
    FILESDIR=\"${ridir}/share/${rname}\" \
    HAVE_RULES=yes \
    CC=\"\${CC}\" \
    CXX=\"\${CXX}\" \
    CPPFLAGS=\"\" \
    CFLAGS=\"-Wl,-static -fPIC\" \
    CXXFLAGS=\"-Wl,-static -fPIC -DNDEBUG\" \
    LDFLAGS=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/pcre/current/bin:\${PATH}\" make install \
    PREFIX=\"${ridir}\" \
    FILESDIR=\"${ridir}/share/${rname}\" \
    HAVE_RULES=yes
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
