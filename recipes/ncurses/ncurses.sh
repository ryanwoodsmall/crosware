#
# XXX - need to maintain version symlinks for hard-coded paths to termcap/terminfo files
# XXX - need to track current? ftp://ftp.invisible-island.net/pub/ncurses/current/
#

rname="ncurses"
rver="6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d"
# cmp, use toybox
rreqs="make toybox sed"

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
  ./configure ${cwconfigureprefix} --without-shared -without-cxx-shared --enable-pc-files ${cwconfigurefpicopts}
  make -j${cwmakejobs}
  make install
  make clean
  ./configure ${cwconfigureprefix} --without-shared -without-cxx-shared --enable-pc-files --enable-widec ${cwconfigurefpicopts}
  make -j${cwmakejobs}
  make install
  for v in 6.0 6.1 ; do
    test -e \"${rtdir}/${rname}-\${v}\" || ln -s \"${rtdir}/current\" \"${rtdir}/${rname}-\${v}\"
  done
  unset v
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}() {
  cwclean_${rname}
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract_${rname}
  cwbuild_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
