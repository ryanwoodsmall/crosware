rname="grep"
rver="3.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="498d7cc1b4fb081904d87343febb73475cf771e424fb7e6141aff66013abc382"
rreqs="make pcre2 sed pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --program-prefix=g --disable-nls
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  ln -sf g${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ge${rname} \"\$(cwidir_${rname})/bin/e${rname}\"
  ln -sf gf${rname} \"\$(cwidir_${rname})/bin/f${rname}\"
  sed -i '/obsolescent/s,^,#,g' \"\$(cwidir_${rname})/bin/ge${rname}\"
  sed -i '/obsolescent/s,^,#,g' \"\$(cwidir_${rname})/bin/gf${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
