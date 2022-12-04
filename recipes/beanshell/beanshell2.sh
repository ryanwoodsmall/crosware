rname="beanshell2"
rver="2.1.1"
rdir="${rname}-${rver}"
rfile="bsh-${rver}.jar"
rurl="https://github.com/beanshell/beanshell/releases/download/${rver}/${rfile}"
rsha256="71192cbbe49e7a269cfcba05dc5cb959c33b9b26dafcd6266ca3288b461f86a3"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  local c=\"\$(cwidir_${rname})/bin/${rname}\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 644 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/\$(cwfile_${rname})\"
  ln -sf \"\$(cwfile_${rname})\" \"\$(cwidir_${rname})/${rname}.jar\"
  ln -sf \"\$(cwfile_${rname})\" \"\$(cwidir_${rname})/beanshell.jar\"
  ln -sf \"\$(cwfile_${rname})\" \"\$(cwidir_${rname})/bsh.jar\"
  ln -sf \"\$(cwfile_${rname})\" \"\$(cwidir_${rname})/bsh2.jar\"
  echo > \"\${c}\"
  echo '#!/usr/bin/env bash' >> \"\${c}\"
  echo 'rlwrap -C ${rname} java -cp \"${rtdir}/current/${rname}.jar\" bsh.Interpreter \"\${@}\"' >> \"\${c}\"
  chmod 755 \"\${c}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/beanshell\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/bsh\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/bsh2\"
  unset c
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
