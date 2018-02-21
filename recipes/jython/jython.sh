rname="jython"
rver="2.7.1"
rurl="https://repo1.maven.org/maven2/org/python/${rname}-installer/${rver}/${rname}-installer-${rver}.jar"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="6e58dad0b8565b95c6fb14b4bfbf570523d1c5290244cfb33822789fa53b1d25"
rprof="${cwetcprofd}/${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  unset JYTHON_HOME
  test -e "${cwsw}/${rname}/${rdir}" && mv "${cwsw}/${rname}/${rdir}"{,.PRE-$(date '+%Y%m%d%H%M%S')}
  java -jar "${cwdl}/${rfile}" -s -t all -d "${cwsw}/${rname}/${rdir}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'JYTHON_HOME=\"${cwsw}/${rname}/current\"' > ${rprof}
  echo 'append_path \"\${JYTHON_HOME}/bin\"' >> ${rprof}
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
