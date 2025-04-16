rname="neon"
rver="0.34.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://notroj.github.io/neon/${rfile}"
rsha256="f98ce3c74300be05eddf05dccbdca498b14d40c289f773195dd1a559cffa5856"
rreqs="make expat zlib openssl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-auto-libproxy \
    --disable-nls \
    --enable-webdav \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-expat \
    --with-ssl=openssl \
    --with-zlib \
    --without-{egd,gssapi,libproxy,libxml2,pakchois} \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"
