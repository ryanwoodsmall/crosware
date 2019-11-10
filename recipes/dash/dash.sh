rname="dash"
rver="0.5.10.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="3c663919dc5c66ec991da14c7cf7e0be8ad00f3db73986a987c118862b5f6071"
rreqs="make netbsdcurses byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-static \
    --with-libedit \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      CFLAGS=\"\${CFLAGS} -L${cwsw}/netbsdcurses/current/lib\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -ledit -lcurses -lterminfo -static\" \
      LIBS=\"-ledit -lcurses -lterminfo -static\" \
      YACC=byacc
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
