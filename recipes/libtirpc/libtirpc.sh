rname="libtirpc"
rver="1.3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rver}/${rfile}/download"
rsha256="e24eb88b8ce7db3b7ca6eb80115dd1284abc5ec32a8deccfed2224fc2532b9fd"
rreqs="make libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
