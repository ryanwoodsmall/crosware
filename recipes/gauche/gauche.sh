#
# XXX - no gc on riscv64 yet
# XXX - add explicit mbedtls+axtls support
#

rname="gauche"
rver="0.9.11"
rdir="${rname//g/G}-${rver}"
rfile="${rdir}.tgz"
rurl="https://github.com/shirok/${rname//g/G}/releases/download/release${rver//./_}/${rfile}"
rsha256="395e4ffcea496c42a5b929a63f7687217157c76836a25ee4becfcd5f130f38e4"
rreqs="make libressl rlwrap"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

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
  echo 'export GAUCHE_READ_EDIT=yes' >> \"${ridir}/bin/${rname}\"
  echo 'env GAUCHE_READ_EDIT=yes gosh' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
