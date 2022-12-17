#
# XXX - libidn/libidn2 stuff
#
rname="dnsmasq"
rver="2.88"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://www.thekelleys.org.uk/${rname}/${rfile}"
rsha256="23544deda10340c053bea6f15a93fed6ea7f5aaa85316bfc671ffa6d22fbc1b3"
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
  cwmkdir \"\$(cwidir_${rname})/share/etc\"
  install -m 0644 \"${rname}.conf.example\" \"\$(cwidir_${rname})/share/etc/\"
  test -e \"${cwetc}/${rname}.conf\" || install -m 0644 \"${rname}.conf.example\" \"${cwetc}/${rname}.conf\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
