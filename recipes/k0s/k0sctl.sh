rname="k0sctl"
rver="0.17.8"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}-linux-x64"
  rsha256="1b7a9e7bfb656911e75d558a4bcc89bce7d027da0f770a3df72f5357b7c6003e"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-linux-arm64"
  rsha256="f67c005bbb3de4d9f44962e91fe7de1e71d78b12aa0408e24c127fc595d87466"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-linux-arm"
  rsha256="e187fe71cc082a24c7b980cb6a5b34ec24ddbb66db46d37eb70be2324434f458"
fi
rurl="https://github.com/k0sproject/${rname}/releases/download/v${rver}/${rfile}"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  test -z \"\$(cwsha256_${rname})\" && cwfailexit \"${rname} does not support \${karch}\"
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export DISABLE_TELEMETRY=true' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
