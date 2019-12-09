rname="minischeme"
rver="0.85ce1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/catseye/minischeme/archive/0.85ce1.tar.gz"
rsha256="879bbf0fcc0b90ca52eda8013a3c8e1eb0fe7356a87247cb230ada18300fc6e2"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CFLAGS=\"\${CFLAGS} -O -ansi -pedantic -DBSD -DCMDLINE\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 miniscm \"${ridir}/bin/miniscm\"
  install -m 0644 *.scm \"${ridir}/bin/\"
  echo '#!/usr/bin/env bash' > \"${ridir}/bin/${rname}\"
  echo '( cd ${rtdir}/current/bin ; ./miniscm \"\${@}\" )' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
