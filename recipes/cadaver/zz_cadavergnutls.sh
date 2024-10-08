rname="cadavergnutls"
rver="$(cwver_cadaver)"
rdir="$(cwdir_cadaver)"
rfile="$(cwfile_cadaver)"
rdlfile="$(cwdlfile_cadaver)"
rurl="$(cwurl_cadaver)"
rsha256=""
rreqs="make expat zlib gnutls libtasn1 libunistring nettle gmp neongnutls netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

local f
for f in clean fetch extract patch make ; do
  eval "function cw${f}_${rname}() { cw${f}_cadaver ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local pkgconfpath=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  env PATH=\"${cwsw}/neon${rname#cadaver}/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-nls \
      --enable-readline \
      --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
      --with-neon=\"${cwsw}/neon${rname#cadaver}/current\" \
      --with-ssl=gnutls \
      --without-{egd,gssapi,lib{iconv,intl}-prefix,libproxy,pakchois} \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\${pkgconfpath}\" \
        LIBS='-lgnutls -ltasn1 -lunistring -lhogweed -lgmp -lnettle -lreadline -lcurses -lterminfo'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname%gnutls}
  test -e \"\$(cwidir_${rname})/bin/${rname}\" || ln -s ${rname%gnutls} \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
