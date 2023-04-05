rname="ppplibressl"
rver="$(cwver_ppp)"
rdir="$(cwdir_ppp)"
rfile="$(cwfile_ppp)"
rdlfile="$(cwdlfile_ppp)"
rurl="$(cwurl_ppp)"
rsha256=""
rreqs="make libressl libpcap libnl pkgconfig"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

local f
for f in clean fetch extract make ; do
  eval "function cw${f}_${rname}() { cw${f}_ppp ; }"
done
unset f

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwpatch_${rname%libressl}
  grep -rl ssl_msg_callback . | xargs sed -i.ORIG s,ssl_msg_callback,pppd_ssl_msg_callback,g
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-{multilink,plugins,eaptls,peap,microsoft-extensions} \
    --disable-{systemd,openssl-engine} \
    --with-openssl=\"${cwsw}/libressl/current\" \
    --with-pcap=\"${cwsw}/libpcap/current\" \
    --without-{srp,atm,pam,gtk} \
      CFLAGS=-fPIC \
      CXXFLAGS=-fPIC \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lpcap -lnl-3 -lnl-genl-3 -lssl -lcrypto'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  rm -rf \"\$(cwidir_${rname})/etc/ppp\"
  cwmkdir \"\$(cwidir_${rname})/etc/ppp\"
  ( cd etc.ppp ; tar cf - . ) | ( cd \"\$(cwidir_${rname})/etc/ppp\" ; tar xvf - )
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
