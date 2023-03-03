rname="ethtool"
rver="6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/software/network/${rname}/${rfile}"
rsha256="86df0114064d4d73f6bf72bf03e85c33964a519ee0c1d1ba65005ad2d0e570e1"
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
