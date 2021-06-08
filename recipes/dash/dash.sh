rname="dash"
rver="0.5.11.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="4e15b7ba5363bcc2a443549910cdc15b5ad601df8196b5f294c712eff037e08d"
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
