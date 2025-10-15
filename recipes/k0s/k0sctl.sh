rname="k0sctl"
rver="0.26.0"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rbfile="${rname}-linux"
rburl="https://github.com/k0sproject/k0sctl/releases/download/v${rver}"
if [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rbfile}-amd64"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rbfile}-arm"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rbfile}-arm64"
fi
rurl="${rburl}/${rfile}"
unset rbfile
unset rburl

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

cwprependfunc cwinstall 'if [[ ${karch} =~ ^(i.86|riscv64) ]] ; then cwscriptecho "'${rname}' not supported on ${karch}" ; return ; fi'

eval "
function cwfetch_${rname}() {
  local s=\"\$(dirname \$(cwdlfile_${rname}))/checksums.txt\"
  local u=\"\$(cwurl_${rname})\"
  u=\"\${u%/*}\"
  u=\"\${u}/checksums.txt\"
  cwfetch \"\${u}\" \"\${s}\"
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(grep \\*\$(cwfile_${rname})\$ \${s} | awk '{print \$1}')\"
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
