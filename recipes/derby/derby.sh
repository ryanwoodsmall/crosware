#
# XXX - derbyjdk8 package with 10.14.x.x?
# XXX - use a mirror?
#

rname="derby"
rver="10.15.2.0"
rdir="db-${rname}-${rver}-bin"
rfile="${rdir}.tar.gz"
#rurl="http://www-us.apache.org/dist//db/${rname}/db-${rname}-${rver}/${rfile}"
rurl="https://archive.apache.org/dist/db/derby/db-${rname}-${rver}/${rfile}"
rsha256="ac51246a2d9eef70cecd6562075b30aa9953f622cbd2cd3551bc3d239dc6f02a"
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
