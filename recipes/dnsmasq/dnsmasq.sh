#
# XXX - libidn/libidn2 stuff
# XXX - nettle support for dnssec/etc.?
#
rname="dnsmasq"
rver="2.90"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.thekelleys.org.uk/${rname}/${rfile}"
rsha256="8f6666b542403b5ee7ccce66ea73a4a51cf19dd49392aaccd37231a2c51b303b"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat bld/get-version > bld/get-version.ORIG
  echo '#!/usr/bin/env bash' > bld/get-version
  echo 'echo ${rver}' >> bld/get-version
  sed -i.ORIG \"s#^PREFIX.*#PREFIX = \$(cwidir_${rname})#g\" Makefile
  sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g' src/dnsmasq.h
  sed -i.ORIG 's#/etc/dnsmasq.conf#${cwetc}/${rname}.conf#g' src/config.h
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} CFLAGS=\"\${CFLAGS} -Wall -W -O2\" LDFLAGS=\"-static\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  cwmkdir \"\$(cwidir_${rname})/share/etc\"
  install -m 0644 \"${rname}.conf.example\" \"\$(cwidir_${rname})/share/etc/\"
  test -e \"${cwetc}/${rname}.conf\" || install -m 0644 \"${rname}.conf.example\" \"${cwetc}/${rname}.conf\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
