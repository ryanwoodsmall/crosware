rname="rhino"
rver="1.7.10"
rdir="${rname}-${rver}"
rfile="${rdir}.jar"
rurl="https://repo.maven.apache.org/maven2/org/mozilla/${rname}/${rver}/${rfile}"
rsha256="38eb3000cf56b8c7559ee558866a768eebcbf254174522d6404b7f078f75c2d4"
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
  cwlinkdir "${rdir}" "${rtdir}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
