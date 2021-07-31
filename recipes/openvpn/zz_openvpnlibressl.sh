rname="openvpnlibressl"
rver="$(cwver_openvpn)"
rdir="$(cwdir_openvpn)"
rfile="$(cwfile_openvpn)"
rdlfile="$(cwdlfile_openvpn)"
rurl="$(cwurl_openvpn)"
rsha256=""
rreqs="make libressl zlib lz4 lzo pkgconfig"
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-{plugins,shared} \
    --enable-{lz4,lzo,static} \
    --with-crypto-library=openssl \
      CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,zlib,lzo,lz4}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{libressl,zlib,lzo,lz4}/current/lib) -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  local t=\"${rname//openvpn/}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmakeinstall_openvpn
  rm -f \"${ridir}/sbin/${rname}\"
  rm -f \"${ridir}/sbin/openvpn-\${t}\"
  ln -sf \"${rtdir}/current/sbin/openvpn\" \"${ridir}/sbin/${rname}\"
  ln -sf \"${rtdir}/current/sbin/openvpn\" \"${ridir}/sbin/openvpn-\${t}\"
  popd >/dev/null 2>&1
  unset t
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
