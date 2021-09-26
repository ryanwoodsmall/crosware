#
# XXX - libidn/libidn2 stuff
#
rname="dnsmasq"
rver="2.86"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://www.thekelleys.org.uk/${rname}/${rfile}"
rsha256="28d52cfc9e2004ac4f85274f52b32e1647b4dbc9761b82e7de1e41c49907eb08"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's#^PREFIX.*#PREFIX = ${ridir}#g' Makefile
  sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g' src/dnsmasq.h
  sed -i.ORIG 's#/etc/dnsmasq.conf#${cwetc}/${rname}.conf#g' src/config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} CFLAGS=\"\${CFLAGS} -Wall -W -O2\" LDFLAGS=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  test -e \"${cwetc}/${rname}.conf\" || install -m 0644 ${rname}.conf.example \"${cwetc}/${rname}.conf\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
