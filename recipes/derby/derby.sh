#
# XXX - derbyjdk8 package with 10.14.x.x?
# XXX - use a mirror?
#

rname="derby"
rver="10.15.1.3"
rdir="db-${rname}-${rver}-bin"
rfile="${rdir}.tar.gz"
#rurl="http://www-us.apache.org/dist//db/${rname}/db-${rname}-${rver}/${rfile}"
rurl="https://archive.apache.org/dist/db/derby/db-${rname}-${rver}/${rfile}"
rsha256="eedb0293fea8b7d9cc813371c34935661e42ea8270e72fedd0ffe2a6a29c61ad"
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
