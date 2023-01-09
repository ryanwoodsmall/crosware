rname="gnutlsminimal"
rver="$(cwver_gnutls)"
rdir="$(cwdir_gnutls)"
rbdir="$(cwbdir_gnutls)"
rfile="$(cwfile_gnutls)"
rdlfile="$(cwdlfile_gnutls)"
rurl="$(cwurl_gnutls)"
rsha256="$(cwsha256_gnutls)"
rreqs="make sed byacc nettleminimal slibtool pkgconfig cacertificates"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch make ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%minimal} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/nettleminimal/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --disable-doc \
      --disable-gtk-doc{,-{html,pdf}} \
      --disable-guile \
      --disable-hardware-acceleration \
      --disable-nls \
      --disable-padlock \
      --enable-local-libopts \
      --enable-manpages \
      --enable-openssl-compatibility \
      --enable-sha1-support \
      --enable-ssl3-support \
      --with-default-trust-store-dir=\"${cwetc}/ssl/certs\" \
      --with-default-trust-store-file=\"${cwetc}/ssl/cert.pem\" \
      --with-unbound-root-key-file=\"${cwetc}/${rname%minimal}/unbound/root.key\" \
      --with-nettle-mini \
      --with-included-libtasn1 \
      --with-included-unistring \
      --without-idn \
      --without-p11-kit \
      --without-tpm \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  cd doc/examples/tlsproxy
  \${CC} \
    buffer.c crypto-gnutls.c tlsproxy.c \
    -o ${rname%minimal}-tlsproxy \
    -I../../../ -I\$(cwidir_${rname})/include \
    -L${cwsw}/nettleminimal/current/lib -L\$(cwidir_${rname})/lib \
    -lgnutls -lhogweed -lnettle -static
  install -m 755 ${rname%minimal}-tlsproxy \$(cwidir_${rname})/bin/
  popd >/dev/null 2>&1
}
"
