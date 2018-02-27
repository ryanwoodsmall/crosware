rname="sdkman"
rver="current"
rurl="https://get.sdkman.io"
rfile="get_sdkman_io.bash"
rdir="${rver}"
rsha256=""
# we need real zip and unzip
# PAGER needs to be set, busybox (or less) recipes will set it
rreqs="busybox unzip zip"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch "${rurl}" "${cwdl}/${rfile}"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir "${rtdir}"
  env SDKMAN_DIR="${ridir}" bash "${cwdl}/${rfile}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export SDKMAN_DIR=\"${ridir}\"' > "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwcheckreqs_${rname}
  cwmakeinstall_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
