#
# XXX - make default variant insecure TLS-less for speed compiling/testing/wrapping?
# XXX - libressl variant
#

rname="mosquitto"
rver="2.0.10"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/eclipse/mosquitto/archive/refs/tags/v2.0.10.tar.gz"
rsha256="448e7cf4b422501c0ce7cb33caa8f31ac350118ce9fc5101db852c1f49a7d096"
rreqs="make cares cjson openssl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/DESTDIR.*etc/s,/etc/,${ridir}/etc/,g' Makefile
  sed -i.ORIG 's/-lpthread.*//g;s/-lcjson/-lcjson -lpthread -lssl -lcrypto -lcares/g' apps/mosquitto_ctrl/Makefile
  sed -i.ORIG 's,^prefix.*,prefix=${ridir},g;s,--strip-program=.*,,g' config.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    WITH_DOCS=no \
    WITH_SHARED_LIBRARIES=no \
    WITH_SRV=yes \
    WITH_STATIC_LIBRARIES=yes \
    WITH_STRIP=yes \
    CPPFLAGS=\"\$(echo -I${cwsw}/{openssl,cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{openssl,cares,cjson}/current/lib) -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install \
    WITH_DOCS=no \
    WITH_SHARED_LIBRARIES=no \
    WITH_SRV=yes \
    WITH_STATIC_LIBRARIES=yes \
    WITH_STRIP=yes \
    CPPFLAGS=\"\$(echo -I${cwsw}/{openssl,cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{openssl,cares,cjson}/current/lib) -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
