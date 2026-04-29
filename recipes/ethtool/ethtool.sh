#
# XXX - 6.4 has some compilation issues, linux/kernel.h include workaround below
# XXX - mailing list message: https://www.spinics.net/lists/netdev/msg658962.html
# XXX - 6.19+ is available in git but doesn't have autotools-ed archives (yet)
#
rname="ethtool"
rver="7.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/software/network/ethtool/${rfile}"
rsha256="1a17b13dba2aef3897bb66c6140d88dc19e807b7948de3773d37320daae5266c"
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
