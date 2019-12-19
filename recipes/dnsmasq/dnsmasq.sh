rname="dnsmasq"
rver="2.80"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://www.thekelleys.org.uk/${rname}/${rfile}"
rsha256="cdaba2785e92665cf090646cba6f94812760b9d7d8c8d0cfb07ac819377a63bb"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's#^PREFIX.*#PREFIX = ${ridir}#g' Makefile
  sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g' src/dnsmasq.h
  sed -i.ORIG 's#/usr/local/etc/dnsmasq.conf#${cwetc}/${rname}.conf#g' src/config.h
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
