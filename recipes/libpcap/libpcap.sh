rname="libpcap"
rver="1.9.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.tcpdump.org/release/${rfile}"
rsha256="2edb88808e5913fdaa8e9c1fcaf272e19b2485338742b5074b9fe44d68f37019"
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
  sed -i 's#/\.libs # #g' ${ridir}/bin/pcap-config
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
