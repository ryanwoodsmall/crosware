rname="libpcap"
rver="1.9.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.tcpdump.org/release/${rfile}"
rsha256="635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094"
rreqs="make bison flex libnl"

. "${cwrecipe}/common.sh"

# XXX - yuck
eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ln -s ${cwsw}/libnl/current/include/libnl3/netlink .
  ./configure \
    ${cwconfigureprefix} \
    ${cwconfigurelibopts} \
    --with-pcap=linux \
    --with-libnl=\"${cwsw}/libnl/current\" \
      CPPFLAGS=\"\${CPPFLAGS}\" \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=\"\${LDFLAGS}\"
  echo '#include <limits.h>' >> config.h
  echo '#include <unistd.h>' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install
  sed -i 's#/\\.libs # #g' ${ridir}/bin/pcap-config ${ridir}/lib/pkgconfig/libpcap.pc
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
