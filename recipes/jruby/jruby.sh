rname="jruby"
rver="9.4.6.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/${rname}/${rname}-dist/${rver}/${rfile}"
rsha256="2da14de4152b71fdbfa35ba4687a46ef12cd465740337b549cc1fe6c7c139813"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwmake_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
