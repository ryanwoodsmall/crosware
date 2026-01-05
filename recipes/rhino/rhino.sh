rname="rhino"
rver="1.9.0"
rdir="${rname}-all-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/rhino-all/${rver}/${rfile}"
rsha256="caafa887e3b32efa74f1aac9984f0f54e733ff5a0ea62b057861c053a6619328"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/${rname}-all.jar\"
  cp \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/${rname}-all.jar\"
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/${rname}\"
  echo '${cwsw}/rlwrap/current/bin/rlwrap -C ${rname} java -jar \"${rtdir}/current/${rname}-all.jar\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ${rname}-all.jar \$(cwidir_${rname})/${rname}.jar
  cwchmod \"755\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
