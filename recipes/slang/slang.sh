#
# XXX - opts
#  oniguruma: --with-onig
#  pcre: --with-pcre
#  zlib: --with-z
# XXX - switch over to netbsdcurses
#
rname="slang"
rver="2.3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.jedsoft.org/releases/${rname}/${rfile}"
rsha256="fc9e3b0fc4f67c3c1f6d43c90c16a5c42d117b8e28457c5b46831b8b5d3ae31a"
rreqs="make zlib ncurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG 's/-ltermcap/-lncurses/g' configure
  sed -i 's/ncurses5-config/ncurses6-config/g' configure
  sed -i 's/ncursesw5-config/ncursesw6-config/g' configure
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j${cwmakejobs} static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install-static
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
