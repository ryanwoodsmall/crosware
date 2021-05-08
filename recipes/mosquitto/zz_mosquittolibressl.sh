rname="mosquittolibressl"
rreqs="make cares cjson libressl"

. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{libressl,cares,cjson}/current/lib) -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local b p d
  rm -f ${ridir}/{,s}bin/*-libressl || true
  make install \
    CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,cares,cjson}/current/include)\" \
    {LOCAL_,}LDFLAGS=\"\$(echo -L${cwsw}/{libressl,cares,cjson}/current/lib) -static\"
  for b in \$(find ${ridir}/{,s}bin/ ! -type d) ; do
    p=\"\$(basename \${b})\"
    d=\"\$(dirname \${b})\"
    ln -sf \"\${p}\" \"\${d}/\${p}-libressl\"
  done
  unset b p d
  popd >/dev/null 2>&1
}
"
