rname="dash"
rver="0.5.13.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="d10dfd41cda59165560db39ca915c2c4a7636fff04281d8d2df77ad92c753e2b"
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
