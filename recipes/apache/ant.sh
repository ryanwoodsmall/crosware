rname="ant"
rver="1.10.15"
rdir="apache-${rname}-${rver}"
rfile="${rdir}-bin.tar.gz"
rurl="https://dlcdn.apache.org//ant/binaries/${rfile}"
rsha256="71334d7e5d98cfe53d6c429a648a5021137a967378667306c5f613dff5180506"
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
