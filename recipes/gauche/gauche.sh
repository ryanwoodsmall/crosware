#
# XXX - no gc on riscv64 yet
#

rname="gauche"
rver="0.9.9"
rdir="${rname//g/G}-${rver}"
rfile="${rdir}.tgz"
rurl="https://github.com/shirok/${rname//g/G}/releases/download/release${rver//./_}/${rfile}"
rsha256="4ca9325322a7efadb9680d156eb7b53521321c9ca4955c4cbe738bc2e1d7f7fb"
rreqs="make openssl rlwrap"

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
