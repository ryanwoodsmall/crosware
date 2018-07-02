rname="kawa"
rver="3.0"
rurl="ftp://ftp.gnu.org/pub/gnu/${rname}/${rname}-${rver}.zip"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="63116eec4b2b2dd8fae0b30127639aa42ad7a7430c4970d3fd76b42a148e423c"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir "${rtdir}"
  test -e "${ridir}" && mv "${ridir}"{,.PRE-${TS}}
  unzip -o "${cwdl}/${rname}/${rfile}" -d "${rtdir}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export KAWA_HOME=\"${rtdir}/current\"' > "${rprof}"
  echo 'append_path \"\${KAWA_HOME}/bin\"' >> "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwcheckreqs_${rname}
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
