rname="xxhash"
rver="0.8.2"
rdir="${rname/h/H}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/Cyan4973/${rname}/archive/${rfile}"
rsha256="baee0c6afd4f03165de7a4e67988d16f0f2b257b51d0e3cb91909302a26a79c4"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cp Makefile{,.ORIG}
  sed -i '/^lib:/s/:.*/: libxxhash.a/g' Makefile
  sed -i '/INSTALL_PROGRAM.*LIBXXH/d' Makefile
  sed -i '/ln -.*LIBXXH/d' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static \
    make -j${cwmakejobs} ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static \
    make install ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\"
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
