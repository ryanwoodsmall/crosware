rname="jython"
rver="2.7.3"
rdir="${rname}-${rver}"
rfile="${rname}-installer-${rver}.jar"
rurl="https://repo.maven.apache.org/maven2/org/python/${rname}-installer/${rver}/${rfile}"
rsha256="3ffc25c5257d2028b176912a4091fe048c45c7d98218e52d7ce3160a62fdc9fc"
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
