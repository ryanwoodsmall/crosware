rname="cloc"
rver="2.00"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/v${rver}/${rfile}"
rsha256="2e8d7d57112b0af14d8578d8679423b6e82f1007b29f71c71510f0bc09563b95"
rreqs="perl"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/bin/\"
  ln -sf \"\$(cwfile_${rname})\" \"\$(cwidir_${rname})/bin/${rname}.pl\"
  ln -sf \"\$(cwfile_${rname})\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
