rname="xxhash"
rver="0.8.1"
rdir="${rname/h/H}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/Cyan4973/${rname}/archive/${rfile}"
rsha256="3bb6b7d6f30c591dd65aaaff1c8b7a5b94d81687998ca9400082c739a690436c"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cp Makefile{,.ORIG}
  sed -i '/^lib:/s/:.*/: libxxhash.a/g' Makefile
  sed -i '/INSTALL_PROGRAM.*LIBXXH/d' Makefile
  sed -i '/ln -.*LIBXXH/d' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} {PREFIX,prefix}=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool} {PREFIX,prefix}=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
