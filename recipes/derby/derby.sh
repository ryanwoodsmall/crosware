#
# XXX - derby 10.15.x.x requires java 9
# XXX - derby 10.16.x.x requires java 17
# XXX - derby 10.17.x.x requires java 21
#
# XXX - derbyjdk8 package with 10.14.x.x
# XXX - derbyjdk11/derbyjdk17/derbyjdk21 (ditto)
# XXX - use a mirror?
#
rname="derby"
rver="10.17.1.0"
rdir="db-${rname}-${rver}-bin"
rfile="${rdir}.tar.gz"
rurl="https://archive.apache.org/dist/db/derby/db-${rname}-${rver}/${rfile}"
rsha256="cbcfe4a0f07aab943cf89978f38d9047a9783233a770c54074bf555a65bedd42"
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
