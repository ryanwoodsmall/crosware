rname="neongnutlsminimal"
rver="$(cwver_neon)"
rdir="$(cwdir_neon)"
rfile="$(cwfile_neon)"
rdlfile="$(cwdlfile_neon)"
rurl="$(cwurl_neon)"
rsha256=""
rreqs="make expat zlib gnutlsminimal nettleminimal"

. "${cwrecipe}/common.sh"

local f
for f in clean fetch extract patch make makeinstall ; do
  eval "function cw${f}_${rname}() { cw${f}_neon ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-auto-libproxy \
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
      LIBS='-lgnutls -lhogweed -lnettle'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  sed -i 's,-lgnutls,-lgnutls -lhogweed -lnettle,g' \"\$(cwidir_${rname})/bin/neon-config\" \"\$(cwidir_${rname})/lib/pkgconfig/neon.pc\"
  popd &>/dev/null
}
"
