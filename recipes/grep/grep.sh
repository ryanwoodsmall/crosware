rname="grep"
rver="3.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/grep/${rfile}"
rsha256="badda546dfc4b9d97e992e2c35f3b5c7f20522ffcbe2f01ba1e9cdcbe7644cdc"
rreqs="make pcre2 sed pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} --program-prefix=g --disable-nls
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install
  ln -sf g${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ge${rname} \"\$(cwidir_${rname})/bin/e${rname}\"
  ln -sf gf${rname} \"\$(cwidir_${rname})/bin/f${rname}\"
  sed -i '/obsolescent/s,^,#,g' \"\$(cwidir_${rname})/bin/ge${rname}\"
  sed -i '/obsolescent/s,^,#,g' \"\$(cwidir_${rname})/bin/gf${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
