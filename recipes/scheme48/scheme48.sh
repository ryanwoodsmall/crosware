rname="scheme48"
rver="1.9.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="http://s48.org/${rver}/${rfile}"
rsha256="9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"
rreqs="make configgit rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    CFLAGS='-Wl,-static -fPIC' \
    CXXFLAGS='-Wl,-static -fPIC' \
    LDFLAGS='-static' \
    CPPFLAGS=''
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  echo '#!/bin/sh' > \"${ridir}/bin/scheme\"
  echo 'rlwrap -pGreen -m -M .scm -q\\\" \"${rtdir}/current/bin/${rname}\" \"\${@}\"' >> \"${ridir}/bin/scheme\"
  chmod 755 \"${ridir}/bin/scheme\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
