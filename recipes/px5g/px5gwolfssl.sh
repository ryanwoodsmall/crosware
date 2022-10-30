rname="px5gwolfssl"
rver="22.03.2"
rdir="${rname}-${rver}"
rfile="${rname%wolfssl}-wolfssl.c"
rurl="https://raw.githubusercontent.com/openwrt/openwrt/v${rver}/package/utils/${rname%wolfssl}-wolfssl/${rfile}"
rsha256="b7f7f241961eb308eb54b3f85b0556c4932e40f4528dc72062dadedb2530ab9b"
rreqs="wolfssl"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  mkdir -p \"\$(cwbdir_${rname})\"
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \${CC} -I\"${cwsw}/wolfssl/current/include\" \"\$(cwdlfile_${rname})\" -o \"${rname%wolfssl}\" -L\"${cwsw}/wolfssl/current/lib\" -lwolfssl -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \$(\${CC} -dumpmachine)-strip --strip-all \"${rname%wolfssl}\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"${rname%wolfssl}\" \"\$(cwidir_${rname})/bin/${rname%wolfssl}\"
  ln -sf \"${rtdir}/current/bin/${rname%wolfssl}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname%wolfssl}\" \"\$(cwidir_${rname})/bin/${rname%wolfssl}-${rname#px5g}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
