rname="libpcap"
rver="1.10.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.tcpdump.org/release/${rfile}"
rsha256="db6d79d4ad03b8b15fb16c42447d093ad3520c0ec0ae3d331104dcfb1ce77560"
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

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  #echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
