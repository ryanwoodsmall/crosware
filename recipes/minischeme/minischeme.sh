rname="minischeme"
rver="0.85ce1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/catseye/${rname}/archive/${rfile}"
rsha256="879bbf0fcc0b90ca52eda8013a3c8e1eb0fe7356a87247cb230ada18300fc6e2"
rreqs="make rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/printf(prompt)/print_prompt()/g' miniscm.c
  sed -i 's#init.scm#${rtdir}/current/share/${rname}/init.scm#g' miniscm.c
  echo 'void print_prompt() { printf(prompt); fflush(stdout); }' >> miniscm.c
  popd >/dev/null 2>&1
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
  strip --strip-all miniscm
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/${rname}\"
  install -m 0755 miniscm \"${ridir}/bin/miniscm\"
  install -m 0644 *.scm \"${ridir}/share/${rname}/\"
  echo '#!/usr/bin/env bash' > \"${ridir}/bin/${rname}\"
  echo 'rlwrap -C ${rname} -pRed -m -M .scm -q\\\" \"${rtdir}/current/bin/miniscm\" \"\${@}\"' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
