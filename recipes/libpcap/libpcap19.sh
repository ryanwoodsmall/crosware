rname="libpcap19"
rver="1.9.1"
rdir="${rname%19}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.tcpdump.org/release/${rfile}"
rsha256="635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094"
rreqs="make bison flex libnl pkgconfig"

. "${cwrecipe}/common.sh"

# XXX - yuck
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ln -s ${cwsw}/libnl/current/include/libnl3/netlink .
  ./configure \
    ${cwconfigureprefix} \
    ${cwconfigurelibopts} \
    --disable-dbus \
    --with-pcap=linux \
    --with-libnl=\"${cwsw}/libnl/current\" \
    --enable-ipv6 \
      CPPFLAGS=\"\${CPPFLAGS}\" \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=\"\${LDFLAGS}\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  echo '#include <limits.h>' >> config.h
  echo '#include <unistd.h>' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  sed -i 's#/\\.libs # #g' \$(cwidir_${rname})/bin/pcap-config \$(cwidir_${rname})/lib/pkgconfig/libpcap.pc
  popd >/dev/null 2>&1
}
"
