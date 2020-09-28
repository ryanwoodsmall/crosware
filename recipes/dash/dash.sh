rname="dash"
rver="0.5.11.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="73c881f146e329ac54962766760fd62cb8bdff376cd6c2f5772eecc1570e1611"
rreqs="make netbsdcurses byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-static \
    --with-libedit \
    --disable-silent-rules \
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
