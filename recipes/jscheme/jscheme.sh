rname="jscheme"
rver="7.2"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rver}/${rfile}/download"
rsha256="5d3941a94a2fbfc6da76f4b42ccad8cdcc13dc525afe7f44a3ebdb9cadb26008"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
}
"

eval "
function cwextract_${rname}() {
  true
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
