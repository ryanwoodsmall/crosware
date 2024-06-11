rname="k0sctl"
rver="0.18.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}-linux-x64"
  rsha256="8e90eae6397d4538aa39192864cf45cd21e9a356715f790a920937c60d791e05"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-linux-arm64"
  rsha256="98f87293177fe26f20a3441aa7e73d42835bae0315c3f0f93bfc9a14d594395d"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-linux-arm"
  rsha256="958f8f0209ea37726bbe8fc53a3d330a00012eb7fc5ded4555e95f392e21d17b"
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
