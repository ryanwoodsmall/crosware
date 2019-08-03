rname="rhino"
rver="1.7.11"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/${rname}/${rver}/${rfile}"
rsha256="1514cf6fbcda690bfea81e51f0ddc36110bfebfeedfa42c4e5aa97cc0772d130"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwmkdir \"${ridir}\"
  rm -f \"${ridir}/${rname}.jar\"
  cp \"${rdlfile}\" \"${ridir}/${rname}.jar\"
  echo '#!/bin/sh' > \"${ridir}/${rname}\"
  echo 'rlwrap -C ${rname} java -jar \"${rtdir}/current/${rname}.jar\" \"\${@}\"' >> \"${ridir}/${rname}\"
  cwchmod \"755\" \"${ridir}/${rname}\"
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
