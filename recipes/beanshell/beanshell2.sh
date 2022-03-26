rname="beanshell2"
rver="2.1.0"
rdir="${rname}-${rver}"
rfile="bsh-${rver}.jar"
rurl="https://github.com/beanshell/beanshell/releases/download/${rver}/${rfile}"
rsha256="e9a68515dd69d54a648c4497875264a874f6c69ff52d0ddaf4be2204f0f18652"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

for f in clean extract configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwmakeinstall_${rname}() {
  local c=\"${ridir}/bin/${rname}\"
  cwmkdir \"${ridir}/bin\"
  install -m 644 \"${rdlfile}\" \"${ridir}/${rfile}\"
  ln -sf \"${rfile}\" \"${ridir}/${rname}.jar\"
  ln -sf \"${rfile}\" \"${ridir}/beanshell.jar\"
  ln -sf \"${rfile}\" \"${ridir}/bsh.jar\"
  ln -sf \"${rfile}\" \"${ridir}/bsh2.jar\"
  echo > \"\${c}\"
  echo '#!/usr/bin/env bash' >> \"\${c}\"
  echo 'rlwrap -C ${rname} java -cp \"${rtdir}/current/${rname}.jar\" bsh.Interpreter \"\${@}\"' >> \"\${c}\"
  chmod 755 \"\${c}\"
  ln -sf \"${rname}\" \"${ridir}/bin/beanshell\"
  ln -sf \"${rname}\" \"${ridir}/bin/bsh\"
  ln -sf \"${rname}\" \"${ridir}/bin/bsh2\"
  unset c
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
