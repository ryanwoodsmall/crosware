#
# XXX - libidn/libidn2 stuff
#
rname="dnsmasq"
rver="2.87"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://www.thekelleys.org.uk/${rname}/${rfile}"
rsha256="0228c0364a7f2356fd7e7f1549937cbf3099a78d3b2eb1ba5bb0c31e2b89de7a"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s#^PREFIX.*#PREFIX = \$(cwidir_${rname})#g\" Makefile
  sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g' src/dnsmasq.h
  sed -i.ORIG 's#/etc/dnsmasq.conf#${cwetc}/${rname}.conf#g' src/config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} CFLAGS=\"\${CFLAGS} -Wall -W -O2\" LDFLAGS=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
