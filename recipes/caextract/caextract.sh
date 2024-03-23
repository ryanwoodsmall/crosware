#
# XXX - latest sha-256 sum is provided: https://curl.se/ca/cacert.pem.sha256
# XXX - if this doesn't match what we have stored, should indicate an update
#

rname="caextract"
rver="2024-03-11"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/${rfile}"
rsha256="1794c1d4f7055b7d02c2170337b61b48a2ef6c90d77e95444fd2596f4cac609f"
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
