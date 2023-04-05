rname="neongnutls"
rver="$(cwver_neon)"
rdir="$(cwdir_neon)"
rfile="$(cwfile_neon)"
rdlfile="$(cwdlfile_neon)"
rurl="$(cwurl_neon)"
rsha256=""
rreqs="make expat zlib gnutls libtasn1 libunistring nettle gmp"

. "${cwrecipe}/common.sh"

local f
for f in clean fetch extract patch make makeinstall ; do
  eval "function cw${f}_${rname}() { cw${f}_neon ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
    --enable-webdav \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-expat \
    --with-ssl=gnutls \
    --with-zlib \
    --without-{egd,gssapi,libproxy,libxml2,pakchois} \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lgnutls -ltasn1 -lunistring -lhogweed -lgmp -lnettle'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  sed -i 's,-lgnutls,-lgnutls -ltasn1 -lunistring -lhogweed -lgmp -lnettle,g' \"\$(cwidir_${rname})/bin/neon-config\" \"\$(cwidir_${rname})/lib/pkgconfig/neon.pc\"
  popd >/dev/null 2>&1
}
"
