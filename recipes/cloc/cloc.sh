rname="cloc"
rver="1.96"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/v${rver}/${rfile}"
rsha256="099b5223029a6d29192d527024a90ec89bee75fc19ec6f4d65a1de4e8791af3c"
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
