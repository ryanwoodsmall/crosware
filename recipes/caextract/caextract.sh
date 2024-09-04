#
# XXX - latest sha-256 sum is provided: https://curl.se/ca/cacert.pem.sha256
# XXX - if this doesn't match what we have stored, should indicate an update
#
rname="caextract"
rver="2024-07-02"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/${rfile}"
rsha256="1bf458412568e134a4514f5e170a328d11091e071c7110955c9884ed87972ac9"
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
  unset f
}
"
