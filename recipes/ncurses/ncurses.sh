#
# XXX - need to maintain version symlinks for hard-coded paths to termcap/terminfo files
# XXX - need to track current? http://invisible-mirror.net/archives/ncurses/current/
# XXX - this needs a cleanup...
#

rname="ncurses"
rver="6.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://invisible-mirror.net/archives/${rname}/${rfile}"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="6931283d9ac87c5073f30b6290c4c75f21632bb4fc3603ac8100812bed248159"
# cmp, use toybox
rreqs="make toybox sed pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include/${rname}\"' >> "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include/${rname}w\"' >> "${rprof}"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

eval "
function cwbuild_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --without-shared \
    --without-cxx-shared \
    --enable-pc-files \
    --with-pkg-config-libdir=${ridir}/lib/pkgconfig \
    --with-pkg-config=${cwsw}/pkgconfig/current/bin/pkg-config \
      ${cwconfigurefpicopts} \
        PKG_CONFIG_{LIBDIR,PATH}=\"${ridir}/lib/pkgconfig\"
  make -j${cwmakejobs}
  make install
  make clean
  ./configure ${cwconfigureprefix} \
    --without-shared \
    --without-cxx-shared \
    --enable-pc-files \
    --with-pkg-config-libdir=${ridir}/lib/pkgconfig \
    --with-pkg-config=${cwsw}/pkgconfig/current/bin/pkg-config \
    --enable-widec \
      ${cwconfigurefpicopts} \
        PKG_CONFIG_{LIBDIR,PATH}=\"${ridir}/lib/pkgconfig\"
  make -j${cwmakejobs}
  make install
  for v in 6.0 6.1 6.2 6.3 ; do
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
