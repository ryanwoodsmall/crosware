rname="rhino"
rver="1.7.15"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/${rname}/${rver}/${rfile}"
rsha256="2427fdcbc149ca0a25ccfbb7c71b01f39ad42708773a47816cd2342861766b63"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/${rname}.jar\"
  cp \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/${rname}.jar\"
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/${rname}\"
  echo '${cwsw}/rlwrap/current/bin/rlwrap -C ${rname} java -jar \"${rtdir}/current/${rname}.jar\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}\"
  cwchmod \"755\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
