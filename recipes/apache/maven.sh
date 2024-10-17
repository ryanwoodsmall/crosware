rname="maven"
rver="3.9.9"
rdir="apache-${rname}-${rver}"
rfile="${rdir}-bin.tar.gz"
rurl="https://dlcdn.apache.org/maven/maven-${rver%%.*}/${rver}/binaries/${rfile}"
rsha256="7a9cdf674fc1703d6382f5f330b3d110ea1b512b51f1652846d9e4e8a588d766"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"
cwstubfunc "cwmakeinstall_${rname}"

eval "
function cwextract_${rname}() {
  cwmkdir \"${rtdir}\"
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
