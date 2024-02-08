rname="tnftp"
rver="20230507"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.netbsd.org/pub/NetBSD/misc/${rname}/${rfile}"
rsha256="be0134394bd7d418a3b34892b0709eeb848557e86474e1786f0d1a887d3a6580"
rreqs="make netbsdcurses libeditnetbsdcurses configgit libressl pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} ${cwconfigurelibopts} \
    --enable-editcomplete \
    --enable-ipv6 \
    --enable-ssl \
    --with-openssl=\"${cwsw}/libressl/current\" \
    --without-socks \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -I. -I..\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -ledit -lcurses -lterminfo\" \
      PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
