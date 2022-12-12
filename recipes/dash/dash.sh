rname="dash"
rver="0.5.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://gondor.apana.org.au/~herbert/${rname}/files/${rfile}"
rsha256="6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a"
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
      CFLAGS=\"\${CFLAGS} -O2 -Wl,-s \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -ledit -lcurses -lterminfo -static -s\" \
      LIBS=\"-ledit -lcurses -lterminfo -static -s\" \
      YACC=byacc
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
