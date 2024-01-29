#
# XXX - need to maintain version symlinks for hard-coded paths to termcap/terminfo files
# XXX - need to track current? http://invisible-mirror.net/archives/ncurses/current/
# XXX - this needs a (little more?) cleanup...
# XXX - move to pkgconf
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

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}_base() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  mkdir -p base_build
  cd base_build
  ../configure ${cwconfigureprefix} \
    --without-shared \
    --without-cxx-shared \
    --enable-pc-files \
    --with-pkg-config-libdir=\"\$(cwidir_${rname})/lib/pkgconfig\" \
    --with-pkg-config=${cwsw}/pkgconfig/current/bin/pkg-config \
      ${cwconfigurefpicopts} \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(cwidir_${rname})/lib/pkgconfig\" \
        LDFLAGS=-static \
        CPPFLAGS=
  make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}_wide() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  mkdir -p wide_build
  cd wide_build
  ../configure ${cwconfigureprefix} \
    --without-shared \
    --without-cxx-shared \
    --enable-pc-files \
    --enable-widec \
    --with-pkg-config-libdir=\"\$(cwidir_${rname})/lib/pkgconfig\" \
    --with-pkg-config=${cwsw}/pkgconfig/current/bin/pkg-config \
      ${cwconfigurefpicopts} \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(cwidir_${rname})/lib/pkgconfig\" \
        LDFLAGS=-static \
        CPPFLAGS=
  make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  cwmake_${rname}_base
  cwmake_${rname}_wide
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd base_build
  make install
  cd -
  cd wide_build
  make install
  cd -
  for v in 6.0 6.1 6.2 6.3 ; do
    test -e \"${rtdir}/${rname}-\${v}\" || ln -s \"${rtdir}/current\" \"${rtdir}/${rname}-\${v}\"
  done
  unset v
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc
  popd >/dev/null 2>&1
}
"

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
