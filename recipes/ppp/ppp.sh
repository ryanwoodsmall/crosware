#
# XXX - eap-tls support, openssl conflicting with md5/sha#/... headers
#

rname="ppp"
rver="2.4.9"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ppp-project/${rname}/archive/refs/tags/${rfile}"
rsha256="565bd23aeaf020b00287c4730fad75bfeb87c8e060462a2958c51e5a0f7963e2"
rreqs="make libpcap libnl"

. "${cwrecipe}/common.sh"

# XXX - config placement?
eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat pppd/Makefile.linux > pppd/Makefile.linux.ORIG
  sed -i '/USE_EAPTLS=y/d' pppd/Makefile.linux
  sed -i 's/^#USE_CRYPT=y/USE_CRYPT=y/g' pppd/Makefile.linux
  sed -i 's/-lpcap/-lpcap -lnl-3 -lnl-genl-3/g' pppd/Makefile.linux
  cat configure > configure.ORIG
  sed -i '/^DESTDIR=/s,=.*,=${ridir},g' configure
  sed -i '/^SYSCONF=/s,=.*,=${ridir}/etc,g' configure
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    CC=\"\${CC} \${CFLAGS}\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -static)\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install \
    CC=\"\${CC} \${CFLAGS}\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -static)\"
  rm -rf \"${ridir}/etc/ppp\"
  cwmkdir \"${ridir}/etc/ppp\"
  ( cd etc.ppp ; tar cf - . ) | ( cd \"${ridir}/etc/ppp\" ; tar xvf - )
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
