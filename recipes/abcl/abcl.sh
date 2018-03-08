rname="abcl"
rver="1.5.0"
rdir="${rname}-bin-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://common-lisp.net/project/armedbear/releases/${rver}/${rfile}"
rsha256="f053608efb15beab0e85857900e3e44946cb9efe68329dc99d2397e8263a0690"
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
  cwmkdir "${rtdir}"
  cwextract "${cwdl}/${rname}/${rfile}" "${rtdir}"
  echo '#!/bin/sh' > "${ridir}/${rname}"
  echo "rlwrap -C ${rname} java -jar ${ridir}/${rname}.jar \\\"\\\${@}\\\"" >> "${ridir}/${rname}"
  cwchmod "755" "${ridir}/${rname}"
  cwlinkdir "${rdir}" "${rtdir}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
