rname="rhino"
rver="1.7.12"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/${rname}/${rver}/${rfile}"
rsha256="9187b35bff89b74c3f2113abb64dbd62f2c63b2ac5da631fbd234e54318332d8"
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
