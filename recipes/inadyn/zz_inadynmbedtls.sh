rname="inadynmbedtls"
rver="$(cwver_inadyn)"
rdir="$(cwdir_inadyn)"
rfile="$(cwfile_inadyn)"
rurl="$(cwurl_inadyn)"
rsha256=""
rreqs="make mbedtls libconfuse pkgconfig zlib"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make patch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%mbedtls}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --disable-openssl \
      --enable-mbedtls \
      --without-systemd \
        CFLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\" \
        CXXFLAGS=\"\${CXXFLAGS} -g0 -Os -Wl,-s\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        MbedTLS_CFLAGS=\"-I${cwsw}/mbedtls/current/include\" \
        MbedTLS_LIBS=\"-lmbedx509 -lmbedtls -lmbedcrypto\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname%%mbedtls}\" \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf \"${rname%%mbedtls}\" \"\$(cwidir_${rname})/sbin/${rname%%mbedtls}-${rname##inadyn}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
