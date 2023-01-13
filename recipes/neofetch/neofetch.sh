rname="neofetch"
rver="7.1.0"
rdir="${rname}-${rver}"
rfile="${rname}"
rurl="https://raw.githubusercontent.com/dylanaraps/${rname}/${rver}/${rfile}"
rsha256="3dc33493e54029fb1528251552093a9f9a2894fcf94f9c3a6f809136a42348c7"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
