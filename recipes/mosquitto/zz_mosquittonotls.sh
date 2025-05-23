rname="mosquittonotls"
rreqs="bootstrapmake cares cjson"
: ${rpfile:="${cwrecipe}/mosquitto/${rname}.patches"}

. "${cwrecipe}/${rname%notls}/${rname%notls}.sh.common"

# XXX - ugly
eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i 's/WITH_TLS:=.*/WITH_TLS=no/g' config.mk
  : sed -i 's/WITH_TLS_PSK:=.*/WITH_TLS_PSK=no/g' config.mk
  : sed -i 's/WITH_EC:=.*/WITH_EC=no/g' config.mk
  : sed -i 's/WITH_BRIDGE:=.*/WITH_BRIDGE=no/g' config.mk
  sed -i 's/-lssl//g;s/-lcrypto//g' apps/mosquitto_ctrl/Makefile
  sed -i.ORIG '/INSTALL.*mosquitto_passwd/d' apps/mosquitto_passwd/Makefile
  make \
    CPPFLAGS=\"\$(echo -I${cwsw}/{cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{cares,cjson}/current/lib) -static\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local b p d
  rm -f \$(cwidir_${rname})/{,s}bin/*-{notls,plaintext} || true
  make install \
    CPPFLAGS=\"\$(echo -I${cwsw}/{cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{cares,cjson}/current/lib) -static\"
  for b in \$(find \$(cwidir_${rname})/{,s}bin/ ! -type d) ; do
    p=\"\$(basename \${b})\"
    d=\"\$(dirname \${b})\"
    ln -sf \"\${p}\" \"\${d}/\${p}-notls\"
    ln -sf \"\${p}\" \"\${d}/\${p}-plaintext\"
  done
  unset b p d
  popd &>/dev/null
}
"
