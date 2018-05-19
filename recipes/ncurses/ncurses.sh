rname="ncurses"
rver="6.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17"
# cmp, use toybox
rreqs="make toybox"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include/${rname}\"' >> "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include/${rname}w\"' >> "${rprof}"
}
"

eval "
function cwbuild_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --without-shared -without-cxx-shared ${cwconfigurefpicopts}
  make -j${cwmakejobs}
  make install
  make clean
  ./configure ${cwconfigureprefix} --without-shared -without-cxx-shared --enable-widec ${cwconfigurefpicopts}
  make -j${cwmakejobs}
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwclean_${rname}
  cwextract_${rname}
  cwbuild_${rname}
  cwlinkdir "$(basename ${ridir})" "${rtdir}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
