#
# XXX - 6.4 has some compilation issues
#
rname="ethtool"
rver="6.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/software/network/${rname}/${rfile}"
rsha256="d9425f0a3df138734001fccc4175fe178c025f938460ac25c4ebc39960168822"
rreqs="make libmnl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CC=\"\${CC} -D_GNU_SOURCE\" \
    CXX=\"\${CXX} -D_GNU_SOURCE\" \
    MNL_CFLAGS=\"-I${cwsw}/libmnl/current/include\" \
    MNL_LIBS=\"-L${cwsw}/libmnl/current/lib -lmnl\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  echo '#include <sys/types.h>' >> ethtool-config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
