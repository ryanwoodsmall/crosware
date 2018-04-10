rname="libpcap"
rver="1.8.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.tcpdump.org/release/${rfile}"
rsha256="673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"
rreqs="make bison flex libnl"

. "${cwrecipe}/common.sh"

# XXX - yuck
eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ln -s ${cwtop}/software/libnl/current/include/libnl3/netlink .
  ./configure \
    ${cwconfigureprefix} \
    ${cwconfigurelibopts} \
    --with-pcap=linux \
    --with-libnl=\"${cwtop}/software/libnl/current\" \
      CPPFLAGS=\"\${CPPFLAGS}\" \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=\"\${LDFLAGS}\"
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
