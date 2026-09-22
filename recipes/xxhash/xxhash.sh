rname="xxhash"
rver="0.8.4"
rdir="${rname/h/H}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/Cyan4973/${rname}/archive/${rfile}"
rsha256="5738270935e7c3d38a79b3adf7c9692566ce7895a25f67de43ad52ab504acd32"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cp Makefile{,.ORIG}
  sed -i '/^lib:/s/:.*/: libxxhash.a/g' Makefile
  sed -i '/INSTALL_PROGRAM.*LIBXXH/d' Makefile
  sed -i '/ln -.*LIBXXH/d' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static \
    make -j${cwmakejobs} ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static \
    make install ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\"
  popd &>/dev/null
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

# vim: set ft=bash:
