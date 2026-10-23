#
# XXX - latest sha-256 sum is provided: https://curl.se/ca/cacert.pem.sha256
# XXX - if this doesn't match what we have stored, should indicate an update
#
rname="caextract"
rver="2026-10-20"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/${rfile}"
rsha256="796f1389bfea13c0ed78f663b765baaff54a508e5483786bd6ece73c5e3e3cbe"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  local f=\"\$(basename \$(cwdlfile_${rname}))\"
  cwmkdir \"\$(cwidir_${rname})\"
  rm -f \"\$(cwidir_${rname})/\${f}\"
  install -m 0644 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/\${f}\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/${rname}.pem\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/cacert.pem\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/cert.pem\"
  ln -sf \"\${f}\" \"\$(cwidir_${rname})/ca-bundle.crt\"
  cwmkdir \"${cwetc}/ca-certs/${rname}\"
  rm -f \"${cwetc}/ca-certs/${rname}/cert.pem\" || true
  install -D -m 0644 \"\$(realpath \$(cwidir_${rname})/\${f})\" \"${cwetc}/ca-certs/${rname}/cert.pem\"
  unset f
}
"
