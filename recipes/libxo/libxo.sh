#
# XXX - kind of odd, build a normal static version then a shared version for encoder libenc_*.so files
#
rname="libxo"
rver="1.7.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Juniper/libxo/releases/download/${rver}/${rfile}"
rsha256="d12249ffad3ef04b160e6419adf1bbe7e593a60bb23f0a0a077fa780b214934a"
rreqs="make libbsd libmd configgit"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwfuncecho 'patching for bsd cdefs/queue/etc.'
  sed -i.ORIG 's,sys/cdefs,bsd/sys/cdefs,g;s,sys/queue,bsd/sys/queue,g;s,sys/syslog,syslog,g;s,sys/sysctl,linux/sysctl,g' \
    libxo/xo_encoder.c \
    libxo/xo_humanize.h \
    libxo/xo_syslog.c \
    xopo/xopo.c
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}_static() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    make clean || true
    make distclean || true
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --disable-gettext \
      --enable-filters \
        CPPFLAGS=\"-I${cwsw}/libbsd/current/include -I${cwsw}/libmd/current/include\" \
        LDFLAGS=\"-L${cwsw}/libbsd/current/lib -L${cwsw}/libmd/current/lib -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=
    make -j${cwmakejobs} ${rlibtool}
    make install ${rlibtool}
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}_shared() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    make clean || true
    make distclean || true
    ./configure \
      --prefix=\"\$(cwidir_${rname})/shared\" \
      --disable-gettext \
      --disable-static \
      --enable-static=no \
      --enable-shared{,=yes} \
      --enable-filters \
        CFLAGS=-fPIC \
        CXXFLAGS=-fPIC \
        CPPFLAGS=\"-I${cwsw}/libbsd/current/include -I${cwsw}/libmd/current/include\" \
        LDFLAGS=\"-L${cwsw}/libbsd/current/lib -L${cwsw}/libmd/current/lib\" \
        PKG_CONFIG_{LIBDIR,PATH}=
    make -j${cwmakejobs}
    make install
    cd encoder
    make install \
      CFLAGS=-fPIC \
      CXXFLAGS=-fPIC \
      CPPFLAGS=\"-I${cwsw}/libbsd/current/include -I${cwsw}/libmd/current/include -I\$(cwidir_${rname})/shared/include\" \
      LDFLAGS=\"-L${cwsw}/libbsd/current/lib -L${cwsw}/libmd/current/lib -L\$(cwidir_${rname})/shared/lib\" \
      PKG_CONFIG_{LIBDIR,PATH}\"=\$(cwidir_${rname})/shared/lib/pkgconfig\"
    cd -
    cd \"\$(cwidir_${rname})/lib/libxo/encoder/\"
    ln -sf ../../../shared/lib/libxo/encoder/*.so* ./
    cd -
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname}_static
  cwmakeinstall_${rname}_shared
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
