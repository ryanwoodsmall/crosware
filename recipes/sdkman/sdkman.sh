rname="sdkman"
rver="current"
rurl="https://get.sdkman.io"
rfile="get_sdkman_io.bash"
rdir="${rver}"
rsha256=""
# we need real zip and unzip
# PAGER needs to be set, busybox (or less) recipes will set it
rreqs="busybox unzip zip cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  true
}
"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  sed -i.ORIG 's/sdkman_insecure_ssl=false/sdkman_insecure_ssl=true/g' \"${rdlfile}\"
  sed -i 's/curl /curl --insecure /g' \"${rdlfile}\"
}
"
eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  env SDKMAN_DIR=\"${ridir}\" bash \"${rdlfile}\"
  test -e \"${ridir}/etc/config\" \
    && grep -q sdkman_insecure_ssl=false \"${ridir}/etc/config\" \
    && sed -i.ORIG 's/sdkman_insecure_ssl=false/sdkman_insecure_ssl=true/g' \"${ridir}/etc/config\" \
    || true
  rmdir \"${ridir}/archives\" || true
  test -e \"${ridir}/archives\" && mv ${ridir}/archives{,.PRE-\${TS}} || true
  ln -sf \"${cwdl}/${rname}\" \"${ridir}/archives\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export SDKMAN_DIR=\"${ridir}\"' > \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwcheckreqs_${rname}
  cwconfigure_${rname}
  cwmakeinstall_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
