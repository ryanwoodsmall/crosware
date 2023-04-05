#
# XXX - move config to ${cwetc}/ppp
#
rname="ppp"
rver="2.5.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/ppp/${rfile}"
rsha256="5cae0e8075f8a1755f16ca290eb44e6b3545d3f292af4da65ecffe897de636ff"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  echo '#include <sys/types.h>' >> pppd/config.h.in
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-multilink \
    --disable-{plugins,systemd,eaptls,openssl-engine,peap,microsoft-extensions} \
    --without-{openssl,srp,atm,pam,pcap,gtk} \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
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
