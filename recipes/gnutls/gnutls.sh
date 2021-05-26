rname="gnutls"
rver="3.6.16"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.gnupg.org/ftp/gcrypt/${rname}/v${rver%.*}/${rfile}"
rsha256="1b79b381ac283d8b054368b335c408fedcb9b7144e0c07f531e3537d4328f3b3"
rreqs="make sed byacc nettle gmp libtasn1 libunistring pkgconfig slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat configure > configure.ORIG
  sed -i \"s,/etc/${rname}/config,${cwetc}/${rname}/config,g\" configure
  sed -i \"s,/etc/unbound/root.key,${cwetc}/${rname}/unbound/root.key,g\" configure
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-doc \
    --disable-gtk-doc{,-{html,pdf}} \
    --disable-guile \
    --disable-hardware-acceleration \
    --disable-nls \
    --disable-openssl-compatibility \
    --disable-padlock \
    --enable-local-libopts \
    --enable-manpages \
    --enable-sha1-support \
    --enable-ssl3-support \
    --with-default-trust-store-dir=\"${cwetc}/ssl/certs\" \
    --with-default-trust-store-file=\"${cwetc}/ssl/cert.pem\" \
    --without-idn \
    --without-p11-kit \
    --without-tpm \
      PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
