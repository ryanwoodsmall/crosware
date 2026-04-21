rname="dash"
rver="0.5.13.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="a83727c1299ac4c3d9d43979393b3a4eb00275d5636ae02526e7979d51d6fbd1"
rreqs="make netbsdcurses libeditnetbsdcurses byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-static \
    --with-libedit \
    --disable-silent-rules \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      CFLAGS=\"\${CFLAGS} -O2 -Wl,-s \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -ledit -lcurses -lterminfo -static -s\" \
      LIBS=\"-ledit -lcurses -lterminfo -static -s\" \
      YACC=byacc
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
