rname="jscheme"
rver="7.2"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rver}/${rname}-${rver}.jar/download"
rfile="$(basename ${rurl//\/download/})"
rdir="${rname}-${rver}"
rsha256="5d3941a94a2fbfc6da76f4b42ccad8cdcc13dc525afe7f44a3ebdb9cadb26008"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwmkdir "${ridir}"
  rm -f "${ridir}/${rname}.jar"
  cp "${cwdl}/${rname}/${rfile}" "${ridir}/${rname}.jar"
  echo '#!/bin/sh' > "${ridir}/${rname}"
  echo "rlwrap -C ${rname} java -jar ${ridir}/${rname}.jar \\\"\\\${@}\\\"" >> "${ridir}/${rname}"
  cwchmod "755" "${ridir}/${rname}"
  cwlinkdir_${rname} 
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
