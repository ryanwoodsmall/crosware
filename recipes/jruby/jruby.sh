rname="jruby"
rver="10.0.0.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/jruby/jruby-dist/${rver}/${rfile}"
rsha256="427d9827ed23fe6b4d11fe61665c75dd7476ba36a0438376eb310ce2a8d24733"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwmake_${rname}"
cwstubfunc "cwconfigure_${rname}"

cwcopyfunc "cwinstall_${rname}" "cwinstall_${rname}_real"
eval "
function cwinstall_${rname}() {
  command -v java &>/dev/null || cwfailexit 'java is required for ${rname}; set JAVA_HOME or PATH'
  cwinstall_${rname}_real
}
"

eval "
function cwmakeinstall_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\"
  cwmkdir \"\$(cwidir_${rname})/bin.off\"
  mv \$(cwidir_${rname})/bin/*.{bat,dll,exe} \$(cwidir_${rname})/bin.off/
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
