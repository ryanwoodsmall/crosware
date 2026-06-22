rname="tnftp"
rver="20260211"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/${rfile}"
rsha256="101cda6927e5de4338ad9d4b264304d7d15d6a78b435968a7b95093e0a2efe03"
rreqs="make netbsdcurses libeditnetbsdcurses configgit libressl pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

# vim: set ft=bash:
