rname="k0sctl"
rver="0.19.4"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}-linux-amd64"
  rsha256="ab6b9d9314e7d15c670a796ee4defa84d6871cae977ceaec54ba9e90af29f09f"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-linux-arm64"
  rsha256="97aa8593bdac5e89dd7661416bb99f1b5b17b8ca10ff77f49fe7ea969c1e103e"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-linux-arm"
  rsha256="02eead0eb2a6af8e1fc64381ea5ee6f7456c97aa5959166a796509c1445439a5"
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
