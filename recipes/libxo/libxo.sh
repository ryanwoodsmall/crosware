#
# XXX - kind of odd, build a normal static version then a shared version for encoder libenc_*.so files
#

rname="libxo"
rver="1.5.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Juniper/${rname}/releases/download/${rver}/${rfile}"
rsha256="b2ed5a23a5d70750114ecdc109e2a76d6c674453ef265bff22f80ae81a84fa8c"
rreqs="make libbsd libmd configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,sys/cdefs,bsd/sys/cdefs,g;s,sys/queue,bsd/sys/queue,g;s,sys/syslog,syslog,g;s,sys/sysctl,linux/sysctl,g' \
    libxo/xo_encoder.c \
    libxo/xo_humanize.h \
    libxo/xo_syslog.c \
    xopo/xopo.c
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-gettext \
    CPPFLAGS=\"-I${cwsw}/libbsd/current/include -I${cwsw}/libmd/current/include\" \
    LDFLAGS=\"-L${cwsw}/libbsd/current/lib -L${cwsw}/libmd/current/lib -static\" \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  make clean || true
  make distclean || true
  ./configure ${cwconfigureprefix} \
    --disable-gettext \
    CFLAGS=-fPIC \
    CXXFLAGS=-fPIC \
    CPPFLAGS=\"-I${cwsw}/libbsd/current/include -I${cwsw}/libmd/current/include\" \
    LDFLAGS=\"-L${cwsw}/libbsd/current/lib -L${cwsw}/libmd/current/lib\" \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  make -j${cwmakejobs} ${rlibtool}
  cd encoder
  make install
  popd >/dev/null 2>&1
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
