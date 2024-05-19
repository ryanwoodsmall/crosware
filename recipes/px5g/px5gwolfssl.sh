rname="px5gwolfssl"
rver="23.05.3"
rdir="${rname}-${rver}"
rfile="${rname%wolfssl}-wolfssl.c"
rurl="https://raw.githubusercontent.com/openwrt/openwrt/v${rver}/package/utils/${rname%wolfssl}-wolfssl/${rfile}"
rsha256="29779bd36f64bf4d3c7447ec25c40974963bb3f9dd6421ef2a33327133bf9322"
rreqs="wolfssl"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  mkdir -p \"\$(cwbdir_${rname})\"
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \${CC} -I\"${cwsw}/wolfssl/current/include\" \"\$(cwdlfile_${rname})\" -o \"${rname%wolfssl}\" -L\"${cwsw}/wolfssl/current/lib\" -lwolfssl -static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \$(\${CC} -dumpmachine)-strip --strip-all \"${rname%wolfssl}\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"${rname%wolfssl}\" \"\$(cwidir_${rname})/bin/${rname%wolfssl}\"
  ln -sf \"${rtdir}/current/bin/${rname%wolfssl}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname%wolfssl}\" \"\$(cwidir_${rname})/bin/${rname%wolfssl}-${rname#px5g}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
