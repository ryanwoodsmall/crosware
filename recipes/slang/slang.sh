#
# XXX - opts
#  oniguruma: --with-onig
#  pcre: --with-pcre
#  zlib: --with-z
#
rname="slang"
rver="2.3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.jedsoft.org/releases/${rname}/${rfile}"
rsha256="f9145054ae131973c61208ea82486d5dd10e3c5cdad23b7c4a0617743c8f5a18"
rreqs="make zlib ncurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's/-ltermcap/-lncurses/g' configure
  sed -i 's/ncurses5-config/ncurses6-config/g' configure
  sed -i 's/ncursesw5-config/ncursesw6-config/g' configure
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
