rname="tnftp"
rver="20151004"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://ftp.netbsd.org/pub/NetBSD/misc/${rname}/${rfile}"
rsha256="c94a8a49d3f4aec1965feea831d4d5bf6f90c65fd8381ee0863d11a5029a43a0"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} ${cwconfigurelibopts} \
    --disable-ssl \
    --enable-editcomplete \
    --without-socks \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib/ -static\" \
      LIBS=\"-L${cwsw}/netbsdcurses/current/lib/ -ledit -lcurses -lterminfo\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I. -I..\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
