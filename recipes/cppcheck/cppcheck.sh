rname="cppcheck"
rver="1.87"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/danmar/${rname}/archive/${rfile}"
rsha256="ea7ac1cd2f5c00ecffd596fd0f7281cba44308e565a634fae02b77ecd927c153"
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
