rname="jython"
rver="2.7.1"
rurl="https://repo.maven.apache.org/maven2/org/python/${rname}-installer/${rver}/${rname}-installer-${rver}.jar"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="6e58dad0b8565b95c6fb14b4bfbf570523d1c5290244cfb33822789fa53b1d25"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  unset JYTHON_HOME
  test -e "${ridir}" && mv "${ridir}"{,.PRE-${TS}}
  env PATH=\"\$(echo \${PATH} | tr : '\n' | egrep -v '/(j|p)ython' | xargs echo | tr ' ' :)\" java -jar "${cwdl}/${rname}/${rfile}" -s -t all -d "${ridir}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export JYTHON_HOME=\"${rtdir}/current\"' > "${rprof}"
  echo 'append_path \"\${JYTHON_HOME}/bin\"' >> "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwmakeinstall_${rname}
  cwlinkdir_${rname} 
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
