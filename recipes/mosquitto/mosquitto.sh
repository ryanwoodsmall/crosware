rname="mosquitto"
rver="2.0.22"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/eclipse/${rname}/archive/refs/tags/${rfile}"
rsha256="a2850bd168cd9f1baa954c30994167f9f8c54ee4966ef34738620a48f63657d5"
rreqs="make cares cjson openssl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"/DESTDIR.*etc/s,/etc/,\$(cwidir_${rname})/etc/,g\" Makefile
  sed -i.ORIG 's/-lpthread.*//g;s/-lcjson/-lcjson -lpthread -lssl -lcrypto -lcares/g' apps/mosquitto_ctrl/Makefile
  sed -i.ORIG \"s,^prefix.*,prefix=\$(cwidir_${rname}),g;s,--strip-program=.*,,g\" config.mk
  sed -i 's/^WITH_DOCS:.*/WITH_DOCS:=no/g' config.mk
  sed -i 's/^WITH_SHARED_LIBRARIES:.*/WITH_SHARED_LIBRARIES:=no/g' config.mk
  sed -i 's/^WITH_SRV:.*/WITH_SRV:=yes/g' config.mk
  sed -i 's/^WITH_STATIC_LIBRARIES:.*/WITH_STATIC_LIBRARIES:=yes/g' config.mk
  sed -i 's/^WITH_STRIP:.*/WITH_STRIP:=yes/g' config.mk
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make \
    CPPFLAGS=\"\$(echo -I${cwsw}/{openssl,cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{openssl,cares,cjson}/current/lib) -static\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install \
    CPPFLAGS=\"\$(echo -I${cwsw}/{openssl,cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{openssl,cares,cjson}/current/lib) -static\"
  popd &>/dev/null
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
