rname="libtirpc"
rver="1.3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rver}/${rfile}/download"
rsha256="6474e98851d9f6f33871957ddee9714fdcd9d8a5ee9abb5a98d63ea2e60e12f3"
rreqs="make libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's,/etc/netconfig,${rtdir}/current/etc/netconfig,g' tirpc/netconfig.h
  sed -i.ORIG 's,/etc/bindresvport.blacklist,${rtdir}/current/etc/bindresvport.blacklist,g' src/bindresvport.c
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-gssapi --enable-authdes --enable-ipv6 \
      CPPFLAGS=\"\$(pkg-config --cflags libbsd)\" \
      LDFLAGS=\"\$(pkg-config --libs libbsd) -static\" \
      PKG_CONFIG_{PATH,LIBDIR}=
  grep -ril sys/cdefs . | xargs sed -i 's,sys/cdefs,bsd/sys/cdefs,g'
  grep -ril sys/queue . | xargs sed -i 's,sys/queue,bsd/sys/queue,g'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  cwmkdir \"\$(cwidir_${rname})/etc\"
  install -m 644 doc/netconfig \"\$(cwidir_${rname})/etc/\"
  install -m 644 doc/bindresvport.blacklist \"\$(cwidir_${rname})/etc/\"
  popd >/dev/null 2>&1
}
"
