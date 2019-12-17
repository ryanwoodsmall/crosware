rname="tinyscheme"
rver="1.41"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rdir}/${rfile}/download"
rsha256="eac0103494c755192b9e8f10454d9f98f2bbd4d352e046f7b253439a3f991999"
rreqs="make rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/^SYS_LIBS=/s/$/ -static/g' makefile
  sed -i.ORIG '/putstr.*prompt/s/;/;fflush(stdout);/g' scheme.c
  sed -i 's#init.scm#${rtdir}/current/share/${rname}/init.scm#g' scheme.c
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  strip --strip-all scheme
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/${rname}\"
  install -m 0755 scheme \"${ridir}/bin/${rname}.bin\"
  install -m 0644 init.scm \"${ridir}/share/${rname}/init.scm\"
  echo '#!/usr/bin/env bash' > \"${ridir}/bin/${rname}\"
  echo 'rlwrap -C ${rname} -pYellow -m -M .scm -q\\\" \"${rtdir}/current/bin/${rname}.bin\" \"\${@}\"' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
