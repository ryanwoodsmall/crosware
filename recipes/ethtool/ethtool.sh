#
# XXX - 6.4 has some compilation issues, linux/kernel.h include workaround below
# XXX - mailing list message: https://www.spinics.net/lists/netdev/msg658962.html
#
rname="ethtool"
rver="6.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/software/network/ethtool/${rfile}"
rsha256="a8bee475d991939cad182b7dbcf3a1f139aeed8cb0add73d72084cd71d43282b"
rreqs="make libmnl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CC=\"\${CC} -D_GNU_SOURCE\" \
    CXX=\"\${CXX} -D_GNU_SOURCE\" \
    MNL_CFLAGS=\"-I${cwsw}/libmnl/current/include\" \
    MNL_LIBS=\"-L${cwsw}/libmnl/current/lib -lmnl\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  echo '#include <sys/types.h>' >> ethtool-config.h
  cat uapi/linux/ethtool.h > uapi/linux/ethtool.h.ORIG
  echo '#include <linux/kernel.h>' > uapi/linux/ethtool.h
  cat uapi/linux/ethtool.h.ORIG >> uapi/linux/ethtool.h
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
