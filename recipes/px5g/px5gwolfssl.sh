rname="px5gwolfssl"
rver="21.02"
rdir="${rname%wolfssl}-${rver}"
rfile="${rname%wolfssl}-wolfssl.c"
rurl="https://github.com/openwrt/openwrt/raw/openwrt-${rver}/package/utils/${rname%wolfssl}-wolfssl/${rfile}"
rsha256="5539ab8f20e51cc5f1294b9ae0209bee30eeb010f0fbccda666638ee48469a8d"
rreqs="wolfssl"

. "${cwrecipe}/common.sh"

for f in extract configure ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwmake_${rname}() {
  mkdir -p \"${rbdir}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} -I\"${cwsw}/wolfssl/current/include\" \"${rdlfile}\" -o \"${rname%wolfssl}\" -L\"${cwsw}/wolfssl/current/lib\" -lwolfssl -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \$(\${CC} -dumpmachine)-strip --strip-all \"${rname%wolfssl}\"
  cwmkdir \"${ridir}/bin\"
  install -m 0755 \"${rname%wolfssl}\" \"${ridir}/bin/${rname%wolfssl}\"
  ln -sf \"${rtdir}/current/bin/${rname%wolfssl}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname%wolfssl}\" \"${ridir}/bin/${rname%wolfssl}-${rname#px5g}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
