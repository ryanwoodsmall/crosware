rname="inadyngnutls"
rver="$(cwver_inadyn)"
rdir="$(cwdir_inadyn)"
rfile="$(cwfile_inadyn)"
rurl="$(cwurl_inadyn)"
rsha256=""
rreqs="make libconfuse pkgconfig zlib gnutls libtasn1 libunistring nettle gmp"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%gnutls}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --without-systemd \
        CPPFLAGS=\"\$(echo -I${cwsw}/{gnutls,libtasn1,libunistring,nettle,gmp,libconfuse,zlib}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{gnutls,libtasn1,libunistring,nettle,gmp,libconfuse,zlib}/current/lib) -static\" \
        PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{gnutls,libtasn1,libunistring,nettle,gmp,libconfuse,zlib}/current/lib/pkgconfig | tr ' ' ':')\" \
        PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{gnutls,libtasn1,libunistring,nettle,gmp,libconfuse,zlib}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lz -lgnutls -ltasn1 -lunistring -lhogweed -lgmp -lnettle -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname%%gnutls}\" \"${ridir}/sbin/${rname%%gnutls}-${rname##inadyn}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
