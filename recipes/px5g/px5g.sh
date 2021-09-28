#
# XXX - selfsigned:
#   px5g selfsigned -newkey rsa:2048 -keyout blah.key -out blah.crt -subj /CN=host.name
#

rname="px5g"
rver="21.02"
rdir="${rname}-${rver}"
rfile="${rname}-mbedtls.c"
rurl="https://github.com/openwrt/openwrt/raw/openwrt-${rver}/package/utils/${rname}-mbedtls/${rfile}"
rsha256="cb42a8c59896bb87e46d5e521d7c5a99362b149e15ffa7ca6e3dc87376bc0964"
rreqs="mbedtls"

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
  \${CC} -I\"${cwsw}/mbedtls/current/include\" \"${rdlfile}\" -o \"${rname}\" -L\"${cwsw}/mbedtls/current/lib\" -lmbedtls -lmbedx509 -lmbedcrypto -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \$(\${CC} -dumpmachine)-strip --strip-all \"${rname}\"
  cwmkdir \"${ridir}/bin\"
  install -m 0755 \"${rname}\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
