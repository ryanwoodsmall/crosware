rname="gauche"
rver="0.9.8"
rdir="${rname//g/G}-${rver}"
rfile="${rdir}.tgz"
rurl="https://github.com/shirok/${rname//g/G}/releases/download/release${rver//./_}/${rfile}"
rsha256="3eb30d1051d8b48999fe46511c9f6983057735312c9832b7db13f9db140db74b"
rreqs="make openssl rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    CFLAGS='-fPIC' \
    CXXFLAGS='-fPIC' \
    LDFLAGS= \
    CPPFLAGS= \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  echo '#!/bin/sh' > \"${ridir}/bin/${rname}\"
  echo 'rlwrap -pBlue -m -M .scm -q\\\" \"${rtdir}/current/bin/gosh\" \"\${@}\"' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
