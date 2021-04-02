rname="rhino"
rver="1.7.13"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/${rname}/${rver}/${rfile}"
rsha256="931dda33789d8e004ff5b5478ee3d6d224305de330c48266df7c3e49d52fc606"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  true
}
"

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
