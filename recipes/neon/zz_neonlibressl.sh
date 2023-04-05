rname="neonlibressl"
rver="$(cwver_neon)"
rdir="$(cwdir_neon)"
rfile="$(cwfile_neon)"
rdlfile="$(cwdlfile_neon)"
rurl="$(cwurl_neon)"
rsha256=""
rreqs="make expat zlib libressl"

. "${cwrecipe}/common.sh"

local f
for f in clean fetch extract patch make makeinstall ; do
  eval "function cw${f}_${rname}() { cw${f}_neon ; }"
done
unset f

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwpatch_${rname%libressl}
  sed -i.ORIG s,HAVE_OPENSSL11,FAKE_HAVE_OPENSSL11,g src/ne_openssl.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
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
  popd >/dev/null 2>&1
}
"
