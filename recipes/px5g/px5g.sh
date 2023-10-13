#
# XXX - selfsigned:
#   px5g selfsigned -newkey rsa:2048 -keyout blah.key -out blah.crt -subj /CN=host.name
#

rname="px5g"
rver="23.05.0"
rdir="${rname}-${rver}"
rfile="${rname}-mbedtls.c"
rurl="https://raw.githubusercontent.com/openwrt/openwrt/v${rver}/package/utils/${rname}-mbedtls/${rfile}"
rsha256="d7fd1842959225ef876a53752d98d1d244a711ad40f72a2ef02e47d064798f73"
rreqs="mbedtls"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  mkdir -p \"\$(cwbdir_${rname})\"
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \${CC} -I\"${cwsw}/mbedtls/current/include\" \"\$(cwdlfile_${rname})\" -o \"${rname}\" -L\"${cwsw}/mbedtls/current/lib\" -lmbedtls -lmbedx509 -lmbedcrypto -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \$(\${CC} -dumpmachine)-strip --strip-all \"${rname}\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}mbedtls\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-mbedtls\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
