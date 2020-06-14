rname="dash"
rver="0.5.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="4dd9a6ed5fe7546095157918fe5d784bb0b7887ae13de50e1e2d11e1b5a391cb"
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
