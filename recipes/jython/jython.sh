rname="jython"
rver="2.7.4"
rdir="${rname}-${rver}"
rfile="${rname}-installer-${rver}.jar"
rurl="https://repo.maven.apache.org/maven2/org/python/jython-installer/${rver}/${rfile}"
rsha256="6001f0741ed5f4a474e5c5861bcccf38dc65819e25d46a258cbc0278394a070b"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="bashtiny busybox"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  unset JYTHON_HOME
  test -e \"\$(cwidir_${rname})\" && mv \"\$(cwidir_${rname})\"{,.PRE-\${TS}}
  env \
    PATH=\"${cwsw}/bashtiny/current/bin:${cwsw}/busybox/current/bin:\${JAVA_HOME}/bin\" \
    java -jar \"\$(cwdlfile_${rname})\" -s -t all -d \"\$(cwidir_${rname})\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export JYTHON_HOME=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"\${JYTHON_HOME}/bin\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  : \${JAVA_HOME:=\"\"}
  if [ -z \"\${JAVA_HOME}\" ] ; then
    cwscriptecho \"JAVA_HOME not set, cannot install ${rname}\"
    return
  fi
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
