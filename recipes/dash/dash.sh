rname="dash"
rver="0.5.11.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="db778110891f7937985f29bf23410fe1c5d669502760f584e54e0e7b29e123bd"
rreqs="make netbsdcurses libeditnetbsdcurses byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-static \
    --with-libedit \
    --disable-silent-rules \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      CFLAGS=\"\${CFLAGS} -O2 \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -ledit -lcurses -lterminfo -static\" \
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
