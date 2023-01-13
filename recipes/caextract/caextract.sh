#
# XXX - latest sha-256 sum is provided: https://curl.se/ca/cacert.pem.sha256
# XXX - if this doesn't match what we have stored, should indicate an update
#

rname="caextract"
rver="2023-01-10"
rdir="${rname}-${rver}"
rfile="cacert-${rver}.pem"
rurl="https://curl.se/ca/${rfile}"
rsha256="fb1ecd641d0a02c01bc9036d513cb658bbda62a75e246bedbc01764560a639f0"
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
