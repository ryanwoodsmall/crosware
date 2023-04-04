#
# XXX - disable EC and EVP stuff... not great, but not defined in wolfssl
# XXX - or i don't have wolfssl configured correctly
#
rname="openvpnwolfssl"
rver="$(cwver_openvpn)"
rdir="$(cwdir_openvpn)"
rfile="$(cwfile_openvpn)"
rdlfile="$(cwdlfile_openvpn)"
rurl="$(cwurl_openvpn)"
rsha256=""
rreqs="make wolfssl zlib lz4 lzo pkgconfig libcapng"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

local f
for f in clean extract fetch make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_openvpn
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-{dco,plugins,shared} \
    --enable-{lz4,lzo,static} \
    --with-crypto-library=wolfssl \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  sed -i.ORIG '/0x101.*LIBRESSL/s,101,123,g' src/openvpn/crypto_openssl.c
  echo '#undef OPENSSL_NO_EC' >> config.h
  echo '#define OPENSSL_NO_EC 1' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  local t=\"${rname//openvpn/}\"
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  rm -f \"\$(cwidir_${rname})/sbin/${rname}\"
  rm -f \"\$(cwidir_${rname})/sbin/openvpn-\${t}\"
  ln -sf \"${rtdir}/current/sbin/openvpn\" \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf \"${rtdir}/current/sbin/openvpn\" \"\$(cwidir_${rname})/sbin/openvpn-\${t}\"
  popd >/dev/null 2>&1
  unset t
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
