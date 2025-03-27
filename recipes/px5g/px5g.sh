#
# XXX - selfsigned:
#   px5g selfsigned -newkey rsa:2048 -keyout blah.key -out blah.crt -subj /CN=host.name
# XXX - 24.10.x needs mbedtls 3, i believe; api changes
#
rname="px5g"
rver="23.05.3"
rdir="${rname}-${rver}"
rfile="${rname}-mbedtls.c"
rurl="https://raw.githubusercontent.com/openwrt/openwrt/v${rver}/package/utils/${rname}-mbedtls/${rfile}"
rsha256="493155dfa8e68cb28da67ca22deac8bff136f2cba640180fc8774592002c8e36"
rreqs="mbedtls"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  mkdir -p \"\$(cwbdir_${rname})\"
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \${CC} -I\"${cwsw}/mbedtls/current/include\" \"\$(cwdlfile_${rname})\" -o \"${rname}\" -L\"${cwsw}/mbedtls/current/lib\" -lmbedtls -lmbedx509 -lmbedcrypto -static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \$(\${CC} -dumpmachine)-strip --strip-all \"${rname}\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}mbedtls\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-mbedtls\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
