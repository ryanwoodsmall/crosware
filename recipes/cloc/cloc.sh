rname="cloc"
rver="2.02"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/v${rver}/${rfile}"
rsha256="373b4424acdf4bfb38e735a85c8a0e5731ee789e2fd95df2618d254cbdb7f355"
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
