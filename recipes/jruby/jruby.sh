rname="jruby"
rver="10.0.4.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/jruby/jruby-dist/${rver}/${rfile}"
rsha256="d0260ebc753a5e9ae49be1eec0e4eec907aaf2b7184faaafc879b0ec3253ca24"
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
