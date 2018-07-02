rname="cppcheck"
rver="1.84"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/danmar/${rname}/archive/${rfile}"
rsha256="aaa6293d91505fc6caa6982ca3cd2d949fa1aac603cabad072b705fdda017fc5"
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
