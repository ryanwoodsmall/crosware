rname="derby"
rver="10.14.2.0"
rdir="db-${rname}-${rver}-bin"
rfile="${rdir}.tar.gz"
rurl="http://www-us.apache.org/dist//db/${rname}/db-${rname}-${rver}/${rfile}"
rsha256="980fb0534c38edf4a529a13fb4a12b53d32054827b57b6c5f0307d10f17d25a8"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'export DERBY_HOME=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"\${DERBY_HOME}/bin\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract \"${rdlfile}\" \"${rtdir}\"
  chmod 644 ${ridir}/bin/*.bat
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
