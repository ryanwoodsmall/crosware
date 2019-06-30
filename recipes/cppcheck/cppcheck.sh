rname="cppcheck"
rver="1.88"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/danmar/${rname}/archive/${rfile}"
rsha256="4aace0420d6aaa900b84b3329c5173c2294e251d2e24d8cba6e38254333dde3f"
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
    CFGDIR=\"${ridir}/cfg\" \
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
    CFGDIR=\"${ridir}/cfg\"
    HAVE_RULES=yes
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
