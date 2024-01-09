rname="k0sctl"
rver="0.17.3"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}-linux-x64"
  rsha256="691df629e12e2fc026198595215528ae017edd0c05b406fa91a497d228ef2132"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-linux-arm64"
  rsha256="38d9351e724dd9fad1685af11dcf689ea346e53328e6339ad72ae113ff98f008"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-linux-arm"
  rsha256="3ef2ba73d09c5f396693e51990e271f1c19f0f7c5ea99012801f52914cfb0a1f"
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
