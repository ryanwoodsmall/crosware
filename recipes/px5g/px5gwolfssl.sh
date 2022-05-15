rname="px5gwolfssl"
rver="22.03"
rdir="${rname%wolfssl}-${rver}"
rfile="${rname%wolfssl}-wolfssl.c"
rurl="https://github.com/openwrt/openwrt/raw/openwrt-${rver}/package/utils/${rname%wolfssl}-wolfssl/${rfile}"
rsha256="b7f7f241961eb308eb54b3f85b0556c4932e40f4528dc72062dadedb2530ab9b"
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
