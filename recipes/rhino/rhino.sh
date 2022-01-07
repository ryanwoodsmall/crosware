rname="rhino"
rver="1.7.14"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/${rname}/${rver}/${rfile}"
rsha256="c9290b0d801bf0dbbbc44338e0f769b7650a0c5d04e6bb1aeb85775c0211b003"
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
