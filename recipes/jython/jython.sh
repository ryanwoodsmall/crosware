rname="jython"
rver="2.7.2"
rdir="${rname}-${rver}"
rfile="${rname}-installer-${rver}.jar"
rurl="https://repo.maven.apache.org/maven2/org/python/${rname}-installer/${rver}/${rfile}"
rsha256="36e40609567ce020a1de0aaffe45e0b68571c278c14116f52e58cc652fb71552"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="bash busybox"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  unset JYTHON_HOME
  test -e \"${ridir}\" && mv \"${ridir}\"{,.PRE-\${TS}}
  env \
    PATH=\"${cwsw}/bash/current/bin:${cwsw}/busybox/current/bin:\${JAVA_HOME}/bin\" \
    java -jar \"${rdlfile}\" -s -t all -d \"${ridir}\"
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
