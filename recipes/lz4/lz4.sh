#
# XXX - 1.11.0 broke static linking in a couple places
# XXX - not sure if this was ai or humans and i don't care
#
rname="lz4"
rver="1.11.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/lz4/lz4/archive/${rfile}"
rsha256="247e5fa64da5f7b75ee3dd3bed484076396c9ebe8254d9ccf693eb62800c5e26"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/^BUILD_SHARED:=/s,.*,BUILD_SHARED=no,g' lib/Makefile
  sed -i '/^liblz4: .*LIB/s,.*,liblz4: \$(LIBLZ4),g' lib/Makefile
  sed -i.ORIG '/^LIBLZ4.*=.*SHARED_EXT/s,.*,LIBLZ4=liblz4.a,g' build/make/lz4defs.make
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\" BUILD_SHARED=no BUILD_STATIC=yes
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\" BUILD_SHARED=no BUILD_STATIC=yes
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
