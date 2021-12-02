rname="jruby"
rver="9.3.2.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/${rname}/${rname}-dist/${rver}/${rfile}"
rsha256="26699ca02beeafa8326573c1125c57a5971ba8b94d15f84e6b3baf2594244f33"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract \"${rdlfile}\" \"${rtdir}\"
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
